<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\DB;
use App\Models\Property;


class PlatformAdminController extends Controller
{
    /**
     * Tampilkan dashboard Admin Platform.
     */
    public function dashboard()
    {
        // Hitung jumlah owner
        $activeOwnersCount = User::where('user_role_id', 2)->where('is_banned', false)->count();
        $bannedOwnersCount = User::where('user_role_id', 2)->where('is_banned', true)->count();

        // Hitung jumlah penyewa
        $activeTenantsCount = User::where('user_role_id', 4)->where('is_banned', false)->count();
        $bannedTenantsCount = User::where('user_role_id', 4)->where('is_banned', true)->count();

        // Kirim data ke view
        return view('platform_admin.dashboard', compact(
            'activeOwnersCount',
            'bannedOwnersCount',
            'activeTenantsCount',
            'bannedTenantsCount'
        ));
    }

    /**
     * Tampilkan halaman pengusaha (owner).
     */
    public function pengusaha()
    {
        // Ambil data owner aktif
        $activeOwners = User::where('user_role_id', 2)->where('is_banned', false)->get();

        // Ambil data owner yang dibanned
        $bannedOwners = User::where('user_role_id', 2)->where('is_banned', true)->get();

        // Kirim data ke view
        return view('platform_admin.pengusaha', compact('activeOwners', 'bannedOwners'));
    }

    /**
     * Tampilkan halaman penyewa (tenant).
     */
    public function penyewa()
    {
        // Ambil data penyewa aktif
        $activeTenant = User::where('user_role_id', 4)->where('is_banned', false)->get();

        // Ambil data penyewa yang dibanned
        $bannedTenant = User::where('user_role_id', 4)->where('is_banned', true)->get();

        // Kirim data ke view
        return view('platform_admin.penyewa', compact('activeTenant', 'bannedTenant'));
    }

    /**
     * Tampilkan halaman profil admin.
     */
    public function profil()
    {
        return view('platform_admin.profil');
    }

    /**
     * Perbarui profil admin.
     */
    public function updateProfil(Request $request)
    {
        $user = Auth::user();

        // Validasi input
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|max:255|unique:users,email,' . $user->id,
            'password' => 'nullable|string|min:8',
            'profile_picture' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
        ]);

        // Update nama dan email
        $user->name = $request->name;
        $user->email = $request->email;

        // Update kata sandi jika diisi
        if ($request->filled('password')) {
            $user->password = bcrypt($request->password);
        }

        // Update foto profil jika diunggah
        if ($request->hasFile('profile_picture')) {
            // Hapus foto lama jika ada
            if ($user->profile_picture) {
                Storage::delete('public/' . $user->profile_picture);
            }

            // Simpan foto baru
            $path = $request->file('profile_picture')->store('profile_pictures', 'public');
            $user->profile_picture = $path;
        }
        
        $user->save();

        return redirect()->route('platform_admin.profil')->with('success', 'Profil berhasil diperbarui.');
    }

    /**
     * Banned pengguna berdasarkan ID.
     */
    public function ban($id)
    {
        $user = User::findOrFail($id);
        $user->is_banned = true; // Set status banned
        $user->save();

        // Redirect berdasarkan role pengguna
        if ($user->user_role_id == 2) { // Role ID 2 untuk Owner
            return redirect()->route('platform_admin.pengusaha')->with('success', 'Owner berhasil dibanned.');
        } elseif ($user->user_role_id == 4) { // Role ID 4 untuk Penyewa
            return redirect()->route('platform_admin.penyewa')->with('success', 'Penyewa berhasil dibanned.');
        }

        return redirect()->back()->with('error', 'Role pengguna tidak valid.');
    }

    /**
     * Unban pengguna berdasarkan ID.
     */
    public function unban($id)
    {
        $user = User::findOrFail($id);
        $user->is_banned = false; // Batalkan status banned
        $user->save();

        // Redirect berdasarkan role pengguna
        if ($user->user_role_id == 2) { // Role ID 2 untuk Owner
            return redirect()->route('platform_admin.pengusaha')->with('success', 'Banned Owner berhasil dibatalkan.');
        } elseif ($user->user_role_id == 4) { // Role ID 4 untuk Penyewa
            return redirect()->route('platform_admin.penyewa')->with('success', 'Banned Penyewa berhasil dibatalkan.');
        }

        return redirect()->back()->with('error', 'Role pengguna tidak valid.');
    }

    public function showOwnerDetail($id)
    {
        // Ambil data owner berdasarkan ID
        $owner = DB::table('users')->where('id', $id)->where('user_role_id', 2)->first();

        if (!$owner) {
            return redirect()->route('super_admin.entrepreneurs.approved')->with('error', 'Owner tidak ditemukan');
        }

        // Ambil jumlah properti yang dimiliki oleh owner
        $totalProperties = Property::where('user_id', $id)->count();

        // Ambil daftar properti yang dimiliki oleh owner
        $properties = Property::with(['kostDetail', 'homestayDetail', 'province', 'city', 'district', 'subdistrict'])
            ->where('user_id', $id)
            ->where('isDeleted', false)
            ->get();

        // Kirim data ke tampilan
        return view('platform_admin.show', compact('owner', 'totalProperties', 'properties'));
    }

    public function showPropertyDetails($id)
    {
        $property = Property::with(['kostDetail', 'homestayDetail', 'province', 'city', 'district', 'subdistrict'])->findOrFail($id);

        // Calculate available rooms, total rooms, and availability percentage
        $totalRooms = $property->rooms->count();
        $availableRooms = $property->rooms->where('is_available', true)->count();
        $availablePercentage = ($totalRooms > 0) ? ($availableRooms / $totalRooms) * 100 : 0;

        return view('platform_admin.properties.details', compact('property', 'totalRooms', 'availableRooms', 'availablePercentage'));
    }
}
