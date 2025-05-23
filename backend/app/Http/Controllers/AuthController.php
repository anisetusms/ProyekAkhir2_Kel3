<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Mail;

class AuthController extends Controller
{

    public function landingpage()
    {
        set_time_limit(300);

        $properties = DB::select("CALL viewAll_Properties()");
        return view('login', compact('properties'));
    }

    public function showLoginForm()
    {
        return view('login');
    }

    public function showRegisterForm()
    {
        $userRoles = DB::select("CALL get_user_roles()");
        $userTypes = DB::select('CALL getAllUserTypes()');
        return view('register', compact('userTypes', 'userRoles'));
    }

    public function insertRegister(Request $request)
    {
        // Validasi input
        $request->validate([
            'name' => 'required|string',
            'username' => 'required|string|unique:users,username',
            'email' => 'required|email|unique:users,email',
            'phone' => 'required|string',
            'address' => 'nullable|string',
            'profile_picture' => 'nullable|string',
            'password' => 'required|string|min:6',
            'user_type_id' => 'required|exists:user_types,id',
            'user_role_id' => 'required|exists:user_roles,id',
        ]);

        // Hash password sebelum dikirim ke SP
        $hashedPassword = Hash::make($request->password);

        // Buat token verifikasi (hash dari email)
        $verificationToken = sha1($request->email);

        // Format data dalam JSON untuk dikirim ke Stored Procedure
        $dataUser = json_encode([
            'name' => $request->name,
            'username' => $request->username,
            'email' => $request->email,
            'phone' => $request->phone,
            'address' => $request->address,
            'profile_picture' => $request->profile_picture,
            'password' => $hashedPassword,
            'user_type_id' => $request->user_type_id,
            'user_role_id' => $request->user_role_id,
            'email_verified_at' => null,
            'verification_token' => $verificationToken,
            'is_banned' => false, // Default value
        ]);

        // Panggil Stored Procedure
        $result = DB::select("CALL store_registerUser(?)", [$dataUser]);

        // Pastikan hasil SP tidak kosong
        if (empty($result) || !isset($result[0]->user_id)) {
            return response()->json([
                'message' => 'Gagal mendaftarkan user'
            ], 500);
        }
    }

    public function login(Request $request)
    {
        // Validasi Input
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|string|min:6',
        ]);

        try {
            // Panggil query builder untuk mencari user berdasarkan email
            $user = DB::table('users')
                ->select('id', 'name', 'email', 'password', 'user_role_id', 'status', 'is_banned')
                ->where('email', $request->email)
                ->first();

            if (!$user) {
                return redirect()->route('showLoginForm')->with('error', 'Email tidak ditemukan.');
            }

            // Periksa apakah akun diblokir
            if ($user->is_banned) {
                return redirect()->route('showLoginForm')->with('error', 'Akun Anda telah dibekukan. Silakan hubungi admin.');
            }

            // Periksa apakah status untuk user role 2 (Owner) adalah approved
            if ($user->user_role_id == 2 && $user->status != 'approved') {
                return redirect()->route('showLoginForm')->with('error', 'Akun Anda belum disetujui oleh admin.');
            }

            // Verifikasi Password
            if (!Hash::check($request->password, $user->password)) {
                return redirect()->route('showLoginForm')->with('error', 'Password salah.');
            }

            // Login User ke Laravel
            Auth::loginUsingId($user->id);

            // Redirect sesuai role
            switch ($user->user_role_id) {
                case 1: // Super Admin
                    return redirect()->route('super_admin.dashboard')->with('message', 'Login sebagai Super Admin!');
                case 2: // Owner
                    return redirect()->route('admin.properties.dashboard')->with('message', 'Login sebagai Owner!');
                case 3: // Admin Platform
                    return redirect()->route('platform_admin.dashboard')->with('message', 'Login sebagai Admin Platform!');
                case 4: // Penyewa
                    return redirect()->route('landingpage')->with('message', 'Login sebagai Penyewa!');
                default:
                    return redirect()->route('landingpage')->with('message', 'Login berhasil!');
            }
        } catch (\Exception $e) {
            return redirect()->route('showLoginForm')->with('error', 'Terjadi kesalahan: ' . $e->getMessage());
        }
    }
    public function logout()
    {
        Auth::logout();
        return redirect()->route('landingpage')->with('message', 'Anda telah logout.');
    }
}
