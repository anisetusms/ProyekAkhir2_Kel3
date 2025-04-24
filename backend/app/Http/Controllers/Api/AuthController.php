<?php

namespace App\Http\Controllers\Api;
use App\Models\User;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'username' => 'required|string|max:255',
            // 'gender' => 'required|in:Pria,Wanita',
            // 'phone' => 'required|string|min:12',
            // 'address' => 'required|string|max:255',
            // 'profile_picture' => 'nullable|image|max:2048',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
            'user_role_id' => 'required|integer|exists:user_roles,id', // Tambahkan konfirmasi password
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // $photoPath = null;
        // if ($request->hasFile('profile_picture')) {
        //     $photoPath = $request->file('profile_picture')->store('profile_photos', 'public');
        // }
        // Simpan user baru dengan user_role_id default = 4 (Penyewa)
        $user = User::create([
            'name' => $request->name,
            'username' => $request->username,
            // 'gender' => $request->gender,
            // 'phone' => $request->phone,
            // 'address' => $request->address,
            // 'profile_picture' => $photoPath,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'user_role_id' => $request->user_role_id,
        ]);
        // Buat token
        $token = $user->createToken('authToken')->plainTextToken;

        // Response
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

    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email|max:255',
            'password' => 'required|string|min:8',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(['message' => 'Invalid credentials'], 401);
        }

        $token = $user->createToken('authToken')->plainTextToken;

        return response()->json([
            'message' => 'Login berhasil',
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'user_role_id' => $user->user_role_id,
            ],
            'access_token' => $token,
            'token_type' => 'Bearer',
        ], 200);
    }

    public function me(Request $request)
    {
        return response()->json(['user' => $request->user()]);
    }

    public function logout(Request $request)
    {
        $request->user()->tokens()->delete();

        return response()->json(['message' => 'Successfully logged out']);
    }
}