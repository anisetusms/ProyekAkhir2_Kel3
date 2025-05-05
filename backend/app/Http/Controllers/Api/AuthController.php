<?php

namespace App\Http\Controllers\Api;

use App\Models\User;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class AuthController extends Controller
{
    // Method untuk registrasi user
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'username' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
            'user_role_id' => 'required|integer|exists:user_roles,id',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $user = User::create([
            'name' => $request->name,
            'username' => $request->username,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'user_role_id' => $request->user_role_id,
        ]);

        $token = $user->createToken('authToken')->plainTextToken;

        return response()->json([
            'message' => 'Registrasi berhasil',
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'username' => $user->username,
                'email' => $user->email,
            ],
            'access_token' => $token,
            'token_type' => 'Bearer',
        ], 201);
        Log::debug('Data yang dikirim:', $request->all());
    }

    // Method untuk login user
    public function login(Request $request)
    {
        // Validasi input
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email|max:255',
            'password' => 'required|string|min:8',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            // Mencari user berdasarkan email
            $user = User::where('email', $request->email)->first();

            // Cek jika user tidak ditemukan
            if (!$user) {
                return response()->json(['message' => 'Email tidak ditemukan'], 401);
            }

            // Cek apakah user diblokir
            if ($user->is_banned) {
                return response()->json(['message' => 'Akun Anda dibekukan. Silakan hubungi admin.'], 403);
            }

            // Cek apakah status akun untuk role Owner (user_role_id == 2) adalah approved
            if ($user->user_role_id == 2 && $user->status != 'approved') {
                return response()->json(['message' => 'Akun Anda belum disetujui oleh admin. Silakan menunggu.'], 403);
            }

            // Verifikasi Password menggunakan Hash::check()
            $isPasswordCorrect = Hash::check($request->password, $user->password);

            // Log untuk memeriksa password yang dimasukkan dan hash yang disimpan di database
            Log::debug('Password yang dimasukkan: ', ['password' => $request->password]);
            Log::debug('Hash Password yang disimpan di DB: ', ['hash' => $user->password]);

            if (!$isPasswordCorrect) {
                return response()->json(['message' => 'Password salah'], 401);
            }

            // Jika login berhasil, buat token
            $token = $user->createToken('authToken')->plainTextToken;

            return response()->json([
                'message' => 'Login berhasil',
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'user_role_id' => $user->user_role_id,
                    'status' => $user->status,
                ],
                'access_token' => $token,
                'token_type' => 'Bearer',
            ]);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Terjadi kesalahan: ' . $e->getMessage()], 500);
        }
    }

    // Method untuk mendapatkan data user yang sedang login
    public function me(Request $request)
    {
        return response()->json(['user' => $request->user()]);
    }

    // Method untuk logout user
    public function logout(Request $request)
    {
        $request->user()->tokens()->delete();

        return response()->json(['message' => 'Successfully logged out']);
    }
}
