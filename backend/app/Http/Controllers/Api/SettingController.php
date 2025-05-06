<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rules;
use Illuminate\Support\Str;

class SettingController extends Controller
{
    // Menampilkan profil pengguna
    public function profile(Request $request)
    {
        // Ambil user yang sedang login
        $user = Auth::user();

        // Cek jika user ditemukan
        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'User not found'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $user
        ]);
    }

    // Memperbarui profil pengguna
    public function updateProfile(Request $request)
    {
        // Ambil user yang sedang login
        $user = Auth::user();

        // Validasi input
        $request->validate([
            'name' => 'required|string|max:255',
            'username' => 'required|string|max:255|unique:users,username,' . $user->id,
            'gender' => 'required|in:Pria,Wanita',
            'phone' => 'nullable|string|max:20',
            'address' => 'nullable|string|max:255',
            'profile_picture' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',  // Validasi gambar
        ]);

        // Ambil data yang akan diupdate
        $data = $request->only(['name', 'username', 'gender', 'phone', 'address']);

        // Menangani file gambar jika ada
        if ($request->hasFile('profile_picture')) {
            $file = $request->file('profile_picture');

            // Membuat nama file unik menggunakan UUID
            $filename = Str::uuid() . '.' . $file->getClientOriginalExtension();

            // Menyimpan gambar di storage (pastikan foldernya ada atau buat jika perlu)
            $file->storeAs('public/profile_pictures', $filename);

            // Menyimpan nama file gambar di database
            $data['profile_picture'] = $filename;
        }

        // Memperbarui data pengguna
        $user->update($data);

        return response()->json([
            'success' => true,
            'message' => 'Profil berhasil diperbarui',
            'data' => $user
        ]);
    }

    // Memperbarui password pengguna
    public function updatePassword(Request $request)
    {
        // Validasi input password
        $request->validate([
            'current_password' => ['required', 'current_password'],
            'new_password' => ['required', 'confirmed', Rules\Password::defaults()],
        ]);

        // Memperbarui password
        Auth::user()->update([
            'password' => Hash::make($request->new_password)
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Password berhasil diperbarui'
        ]);
    }
    // SettingController.php

    public function uploadProfilePicture(Request $request)
    {
        $request->validate([
            'profile_picture' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        $user = Auth::user();

        if ($request->hasFile('profile_picture')) {
            $file = $request->file('profile_picture');
            $filename = time() . '.' . $file->getClientOriginalExtension();
            $file->storeAs('public/profile_pictures', $filename);

            // Update user's profile picture in the database
            $user->profile_picture = $filename;
            $user->save();

            return response()->json([
                'success' => true,
                'message' => 'Profile picture uploaded successfully',
                'data' => $user
            ]);
        }

        return response()->json([
            'success' => false,
            'message' => 'No file uploaded'
        ], 400);
    }
}
