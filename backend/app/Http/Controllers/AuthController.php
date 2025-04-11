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
        return view('welcome', compact('properties'));
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
            'email' => 'required',
            'phone' => 'required|string',
            'password' => 'required|string|6',
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
            'password' => $hashedPassword,
            'user_type_id' => $request->user_type_id,
            'user_role_id' => $request->user_role_id,
            'email_verified_at' => null,
            'verification_token' => $verificationToken
        ]);

        // Panggil Stored Procedure
        $result = DB::select("CALL store_registerUser(?)", [$dataUser]);

        // Pastikan hasil SP tidak kosong
        if (empty($result) || !isset($result[0]->user_id)) {
            return response()->json([
                'message' => 'Gagal mendaftarkan user'
            ], 500);
        }

        // Kirim email verifikasi
        $this->sendVerificationEmail($request->email, $result[0]->user_id, $verificationToken);

        return response()->json([
            'message' => 'User registered successfully. Please check your email for verification.',
            'user_id' => $result[0]->user_id
        ], 201);
    }

    private function sendVerificationEmail($email, $userId, $token)
    {
        $verificationUrl = route('email.verify', ['id' => $userId, 'token' => $token]);

        Mail::raw("Klik link berikut untuk verifikasi email Anda: $verificationUrl", function ($message) use ($email) {
            $message->to($email)
                ->subject('Verifikasi Email');
        });
    }

    public function login(Request $request)
    {
        // Validasi Input
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|string|min:6',
        ]);

        try {
            // Panggil Stored Procedure untuk mencari user berdasarkan email
            $userData = DB::select("CALL login_user(?)", [$request->email]);

            if (empty($userData)) {
                return redirect()->route('showLoginForm')->with('error', 'Email tidak ditemukan.');
            }

            // Ambil data user dari hasil SP
            $user = (object) $userData[0];

            // Periksa apakah akun diblokir
            if ($user->is_banned) {
                return redirect()->route('showLoginForm')->with('error', 'Akun Anda telah dibekukan. Silakan hubungi admin.');
            }

            // Verifikasi Password
            if (!Hash::check($request->password, $user->password)) {
                return redirect()->route('showLoginForm')->with('error', 'Password salah.');
            }

            // Login User ke Laravel
            $loggedInUser = User::find($user->id);
            Auth::login($loggedInUser);

            // Redirect Sesuai Role
            switch ($user->user_role_id) {
                case 1: // Super Admin
                    return redirect()->route('super_admin.dashboard')->with('message', 'Login sebagai Super Admin!');
                    // Mutant:
                case 2: // Owner
                    return redirect()->route('owner.dashboard')->with('message', 'Login sebagai Owner!');
                case 3: // User
                    return redirect()->route('landingpage')->with('message', 'Login berhasil!');
                case 4: // Admin Platform
                    return redirect()->route('platform_admin.dashboard')->with('message', 'Login sebagai Admin Platform!');
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

    public function insertUserType(Request $request)
    {
        $dataUserType = json_encode([
            'userType_name' => $request->userType_name,
            'description'   => $request->description
        ]);

        $response = DB::statement('CALL insert_user_type(?)', [$dataUserType]);

        if ($response) {
            return response()->json(['message' => 'User Type berhasil ditambahkan'], 201);
        } else {
            return response()->json(['error' => 'Gagal menambahkan User Type'], 500);
        }
    }

    public function insertUserRole(Request $request)
    {
        $dataUserRole = json_encode([
            'role_name'   => $request->role_name,
            'description' => $request->description
        ]);

        $response = DB::statement('CALL insert_user_role(?)', [$dataUserRole]);

        if ($response) {
            return response()->json(['message' => 'User Role berhasil ditambahkan'], 201);
        } else {
            return response()->json(['error' => 'Gagal menambahkan User Role'], 500);
        }
    }
}
