<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Models\Booking;
use Carbon\Carbon;
use App\Models\Property;

class SuperAdminController extends Controller
{
    public function dashboard()
    {
        // Ambil owner dengan status pending
        $pendingOwners = DB::table('users')
            ->where('user_role_id', 2) // Owner
            ->where('status', 'pending') // Hanya yang statusnya 'pending'
            ->get();

        $user_id = Auth::id();
        $bookings = Booking::with('user', 'property')->latest()->get();
        $totalProperties = Property::count();
        $totalBookings = Booking::count();
        $latestProperties = Property::where('user_id', $user_id)->latest()->take(5)->get();
        $totalViews = 120;
        $totalMessages = 50;
        $pendingOwnerCount = $pendingOwners->count();

        return view('super_admin.dashboard', compact('totalProperties', 'totalBookings', 'latestProperties', 'totalViews', 'totalMessages', 'bookings', 'pendingOwners', 'pendingOwnerCount'));
    }

    public function manageEntrepreneurs()
    {
        $entrepreneurs = DB::select('CALL getAllEntrepreneurs()');
        return view('super_admin.entrepreneurs.index', compact('entrepreneurs'));
    }

    public function addEntrepreneur()
    {
        return view('super_admin.entrepreneurs.create');
    }

    public function managePlatformAdmins()
    {
        $platformAdmins = DB::table('users')->where('user_role_id', 3)->get();
        return view('super_admin.platform_admins.index', compact('platformAdmins'));
    }

    public function createPlatformAdmin()
    {
        return view('super_admin.platform_admins.create');
    }

    public function storeEntrepreneur(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string',
            'email' => 'required|email|unique:users,email',
            'username' => 'required|string|unique:users,username',
            'password' => 'required|string|min:6',
        ]);

        if ($validator->fails()) {
            return redirect()->back()->withErrors($validator)->withInput();
        }

        // Insert entrepreneur ke database
        DB::statement('CALL storeEntrepreneur(?, ?, ?, ?)', [
            $request->name,
            $request->email,
            $request->username,
            bcrypt($request->password),
        ]);

        // Ambil id user yang baru saja disimpan
        $user = DB::table('users')
            ->where('email', $request->email)
            ->first();

        // Update status menjadi 'approved' setelah ditambahkan
        if ($user) {
            DB::table('users')
                ->where('id', $user->id)
                ->update(['status' => 'approved']);
        }

        return redirect()->route('super_admin.entrepreneurs.approved')->with('success', 'Entrepreneur added and approved successfully.');
    }

    public function editEntrepreneur($id)
    {
        $entrepreneur = DB::select('CALL getEntrepreneurById(?)', [$id]);

        if (empty($entrepreneur)) {
            return redirect()->route('super_admin.entrepreneurs.index')->with('error', 'Entrepreneur not found.');
        }

        return view('super_admin.entrepreneurs.edit', ['entrepreneur' => $entrepreneur[0]]);
    }

    public function updateEntrepreneur(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . $id,
        ]);

        if ($validator->fails()) {
            return redirect()->back()->withErrors($validator)->withInput();
        }

        try {
            DB::statement('CALL updateEntrepreneur(?, ?, ?)', [$id, $request->name, $request->email]);
            return redirect()->route('super_admin.entrepreneurs.index')->with('success', 'Entrepreneur updated successfully.');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Failed to update entrepreneur: ' . $e->getMessage());
        }
    }

    public function destroyEntrepreneur($id)
    {
        try {
            DB::statement('CALL deleteEntrepreneur(?)', [$id]);
            return redirect()->route('super_admin.entrepreneurs.index')->with('success', 'Entrepreneur deleted successfully.');
        } catch (\Exception $e) {
            return redirect()->route('super_admin.entrepreneurs.index')->with('error', 'Failed to delete entrepreneur: ' . $e->getMessage());
        }
    }

    public function storePlatformAdmin(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'username' => 'required|string|unique:users,username',
            'password' => 'required|string|min:6|confirmed',
        ]);

        DB::table('users')->insert([
            'name' => $request->name,
            'email' => $request->email,
            'username' => $request->username,
            'password' => bcrypt($request->password),
            'user_role_id' => 3,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return redirect()->route('super_admin.platform_admins.index')->with('success', 'Admin Platform berhasil ditambahkan.');
    }

    public function editPlatformAdmin($id)
    {
        $admin = DB::table('users')->where('id', $id)->where('user_role_id', 3)->first();

        if (!$admin) {
            return redirect()->route('super_admin.platform_admins.index')->with('error', 'Admin Platform tidak ditemukan.');
        }

        return view('super_admin.platform_admins.edit', compact('admin'));
    }

    public function updatePlatformAdmin(Request $request, $id)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . $id,
            'username' => 'required|string|unique:users,username,' . $id,
            'password' => 'nullable|string|min:6|confirmed',
        ]);

        $data = [
            'name' => $request->name,
            'email' => $request->email,
            'username' => $request->username,
            'updated_at' => now(),
        ];

        if ($request->filled('password')) {
            $data['password'] = bcrypt($request->password);
        }

        DB::table('users')->where('id', $id)->update($data);

        return redirect()->route('super_admin.platform_admins.index')->with('success', 'Admin Platform berhasil diperbarui.');
    }

    public function showProfile()
    {
        $admin = Auth::user();
        return view('super_admin.profiles.index', compact('admin'));
    }

    public function editProfile()
    {
        $admin = Auth::user();
        return view('super_admin.profiles.edit', compact('admin'));
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
        return view('super_admin.entrepreneurs.show', compact('owner', 'totalProperties', 'properties'));
    }

    public function updateProfile(Request $request)
    {
        $admin = Auth::user();

        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . $admin->id,
            'username' => 'required|string|unique:users,username,' . $admin->id,
            'password' => 'nullable|string|min:6|confirmed',
        ]);

        $data = [
            'name' => $request->name,
            'email' => $request->email,
            'username' => $request->username,
            'updated_at' => now(),
        ];

        if ($request->filled('password')) {
            $data['password'] = Hash::make($request->password);
        }

        try {
            $admin->update($data);
            return redirect()->route('super_admin.profiles.edit')->with('success', 'Profil berhasil diperbarui.');
        } catch (\Exception $e) {
            return redirect()->route('super_admin.profiles.edit')->with('error', 'Terjadi kesalahan saat memperbarui profil: ' . $e->getMessage());
        }
    }

    // Controller method untuk mengambil data owner yang sedang pending
    public function managePendingOwners()
    {
        // Ambil data owner dengan status 'pending' hanya untuk user_role_id 2 (owner)
        $pendingOwners = DB::table('users')
            ->where('user_role_id', 2)  // Hanya untuk Owner
            ->where('status', 'pending')  // Status harus 'pending'
            ->get();

        return view('super_admin.entrepreneurs.pending', compact('pendingOwners'));
    }


    // public function manageApprovedOwners()
    // {
    //     $approvedOwners = DB::table('users')
    //         ->where('user_role_id', 2) // Hanya owner
    //         ->where('status', 'approved') // Hanya yang sudah disetujui
    //         ->get();

    //     return view('super_admin.entrepreneurs.approved', compact('approvedOwners'));
    // }

    public function manageApprovedOwners()
    {
        // Ambil data owner yang sudah disetujui
        $approvedOwners = DB::table('users')
            ->where('user_role_id', 2) // Hanya owner
            ->where('status', 'approved') // Hanya yang sudah disetujui
            ->get();

        // Menambahkan jumlah properti untuk setiap owner
        foreach ($approvedOwners as $owner) {
            $owner->properties_count = Property::where('user_id', $owner->id)->count(); // Hitung jumlah properti
        }

        return view('super_admin.entrepreneurs.approved', compact('approvedOwners'));
    }


    // Controller (SuperAdminController.php)

    public function approveOwner($id)
    {
        try {
            // Cek apakah owner dengan ID tersebut ada
            $owner = DB::table('users')->where('id', $id)->where('user_role_id', 2)->first();

            // Jika tidak ditemukan, tampilkan error
            if (!$owner) {
                return redirect()->route('super_admin.entrepreneurs.pending')->with('error', 'Owner tidak ditemukan');
            }

            // Update status pengguna menjadi 'approved'
            DB::table('users')->where('id', $id)->update(['status' => 'approved']);

            // Redirect dengan pesan sukses
            return redirect()->route('super_admin.entrepreneurs.pending')->with('success', 'Owner telah disetujui');
        } catch (\Exception $e) {
            // Tangani kesalahan lainnya
            return redirect()->route('super_admin.entrepreneurs.pending')->with('error', 'Terjadi kesalahan: ' . $e->getMessage());
        }
    }
}
