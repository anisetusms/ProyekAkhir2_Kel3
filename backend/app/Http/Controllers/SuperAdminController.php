<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class SuperAdminController extends Controller
{
    public function dashboard()
    {
        return view('super_admin.dashboard');
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
        // Ambil data admin platform dari database
        $platformAdmins = DB::table('users')->where('user_role_id', 4)->get();

        // Tampilkan view dengan data admin platform
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
            'username' => 'required|string|unique:users,username', // Validasi untuk username
            'password' => 'required|string|min:6',
        ]);

        if ($validator->fails()) {
            return redirect()->back()->withErrors($validator)->withInput();
        }

        $dataEntrepreneur = json_encode([
            'name' => $request->name,
            'email' => $request->email,
            'username' => $request->username,
            'password' => bcrypt($request->password),
        ]);

        DB::statement('CALL storeEntrepreneur(?)', [$dataEntrepreneur]);

        return redirect()->route('super_admin.entrepreneurs.index')->with('success', 'Entrepreneur added successfully.');
    }
    public function editEntrepreneur($id)
    {
        // Panggil stored procedure untuk mendapatkan data entrepreneur berdasarkan ID
        $entrepreneur = DB::select('CALL getEntrepreneurById(?)', [$id]);

        // Periksa apakah data ditemukan
        if (empty($entrepreneur)) {
            return redirect()->route('super_admin.entrepreneurs.index')->with('error', 'Entrepreneur not found.');
        }

        // Tampilkan view edit dengan data entrepreneur
        return view('super_admin.entrepreneurs.edit', ['entrepreneur' => $entrepreneur[0]]);
    }

    public function updateEntrepreneur(Request $request, $id)
    {
        // Validasi input
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . $id, // Pastikan email unik kecuali untuk user ini
        ]);

        // Jika validasi gagal, kembalikan ke halaman sebelumnya dengan error
        if ($validator->fails()) {
            return redirect()->back()->withErrors($validator)->withInput();
        }

        // Format data untuk dikirim ke stored procedure
        $dataEntrepreneur = json_encode([
            'id' => $id,
            'name' => $request->name,
            'email' => $request->email,
        ]);

        // Panggil stored procedure untuk mengupdate data entrepreneur
        try {
            DB::statement('CALL updateEntrepreneur(?, ?, ?)', [$id, $request->name, $request->email]);
            return redirect()->route('super_admin.entrepreneurs.index')->with('success', 'Entrepreneur updated successfully.');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Failed to update entrepreneur: ' . $e->getMessage());
        }
    }

    public function destroyEntrepreneur($id)
    {
        // Panggil stored procedure untuk menghapus entrepreneur berdasarkan ID
        try {
            DB::statement('CALL deleteEntrepreneur(?)', [$id]);
            return redirect()->route('super_admin.entrepreneurs.index')->with('success', 'Entrepreneur deleted successfully.');
        } catch (\Exception $e) {
            return redirect()->route('super_admin.entrepreneurs.index')->with('error', 'Failed to delete entrepreneur: ' . $e->getMessage());
        }
    }


    // ADMIN PLATFORM

    //Menambah
    public function storePlatformAdmin(Request $request)
    {
        // Validasi input
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'username' => 'required|string|unique:users,username',
            'password' => 'required|string|min:6|confirmed',
        ]);

        // Simpan admin platform ke database
        DB::table('users')->insert([
            'name' => $request->name,
            'email' => $request->email,
            'username' => $request->username,
            'password' => bcrypt($request->password),
            'user_role_id' => 4, // Role ID untuk Admin Platform
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        // Redirect ke halaman daftar admin platform dengan pesan sukses
        return redirect()->route('super_admin.platform_admins.index')->with('success', 'Admin Platform berhasil ditambahkan.');
    }

    // Mengedit
    public function editPlatformAdmin($id)
    {
        // Ambil data admin platform berdasarkan ID
        $admin = DB::table('users')->where('id', $id)->where('user_role_id', 4)->first();

        // Jika admin tidak ditemukan, redirect dengan pesan error
        if (!$admin) {
            return redirect()->route('super_admin.platform_admins.index')->with('error', 'Admin Platform tidak ditemukan.');
        }

        // Tampilkan view edit dengan data admin
        return view('super_admin.platform_admins.edit', compact('admin'));
    }

    public function updatePlatformAdmin(Request $request, $id)
    {
        // Validasi input
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . $id,
            'username' => 'required|string|unique:users,username,' . $id,
            'password' => 'nullable|string|min:6|confirmed', // Password opsional
        ]);

        // Data yang akan diperbarui
        $data = [
            'name' => $request->name,
            'email' => $request->email,
            'username' => $request->username,
            'updated_at' => now(),
        ];

        // Jika password diisi, tambahkan ke data yang akan diperbarui
        if ($request->filled('password')) {
            $data['password'] = bcrypt($request->password);
        }

        // Update data admin platform di database
        DB::table('users')->where('id', $id)->update($data);

        // Redirect ke halaman daftar admin platform dengan pesan sukses
        return redirect()->route('super_admin.platform_admins.index')->with('success', 'Admin Platform berhasil diperbarui.');
    }



    // EDIT PROFIL
    public function showProfile()
    {
        // Ambil data Super Admin yang sedang login
        $admin = Auth::user();

        // Tampilkan view profil dengan data admin
        return view('super_admin.profiles.index', compact('admin'));
    }

    public function editProfile()
    {
        // Ambil data Super Admin yang sedang login
        $admin = Auth::user();

        // Tampilkan view edit profil dengan data admin
        return view('super_admin.profiles.edit', compact('admin'));
    }

    public function updateProfile(Request $request)
    {
        // Ambil data Super Admin yang sedang login
        $admin = Auth::user();

        // Validasi input
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . $admin->id,
            'username' => 'required|string|unique:users,username,' . $admin->id,
            'password' => 'nullable|string|min:6|confirmed', // Password opsional
        ]);

        // Data yang akan diperbarui
        $data = [
            'name' => $request->name,
            'email' => $request->email,
            'username' => $request->username,
            'updated_at' => now(),
        ];

        // Jika password diisi, tambahkan ke data yang akan diperbarui
        if ($request->filled('password')) {
            $data['password'] = Hash::make($request->password);
        }

        try {
            // Update data Super Admin di database
            $admin->update($data);

            // Redirect dengan pesan sukses
            return redirect()->route('super_admin.profiles.edit')->with('success', 'Profil berhasil diperbarui.');
        } catch (\Exception $e) {
            // Redirect dengan pesan error jika terjadi kesalahan
            return redirect()->route('super_admin.profiles.edit')->with('error', 'Terjadi kesalahan saat memperbarui profil: ' . $e->getMessage());
        }
    }
}
