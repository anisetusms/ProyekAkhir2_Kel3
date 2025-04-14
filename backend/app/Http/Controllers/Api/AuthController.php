<?php

namespace App\Http\Controllers\Api;
use App\Models\User;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(['message' => 'Email atau password salah'], 401);
        }

        $token = $user->createToken('api-token')->plainTextToken;

        return response()->json([
            'message' => 'Login berhasil',
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'user_role_id' => $user->user_role_id,
                'user_role_id' => $user->user_role_id,
                
                //tambah jika perlu brook
            ],
            'token' => $token
        ]);
    }

    
    
    public function register(Request $request)
{
    $request->validate([
        'name' => 'required|string|max:255',
        'username' =>'required|string|max:255',
        'gender' => 'required|in:Pria,Wanita',
        'phone' =>'required|string|min:12',
        'address' =>'required|string|max:255',
        'profile_picture' => 'nullable|image|max:2048',
        'email' => 'required|string|email|max:255|unique:users',
        'password' => 'required|string|min:8', 
        
    ]);

    $photoPath = null;
    if ($request->hasFile('profile_picture')) {
        $photoPath = $request->file('profile_picture')->store('profile_photos', 'public');
    }
    // Simpan user baru dengan user_role_id default = 3
    $user = User::create([
        'name' => $request->name,
        'username' => $request->username,
        'gender' => $request -> gender,
        'phone' => $request->phone,
        'address' => $request->address,
        'profile_picture' => $photoPath,
        'email' => $request->email,
        'password' => Hash::make($request->password),
        'user_role_id' => 4 , 
        'user_type_id' => 4

    ]);

    

    // Buat token
    $token = $user->createToken('api-token')->plainTextToken;

    // Response
    return response()->json([
        'message' => 'Registrasi berhasil',
        'user' => [
            'id' => $user->id,
            'name' => $user->name,
            'username' => $user->username,
            'phone' =>$user-> phone,
            'address' =>$user-> address,
            'email' => $user->email,
        ],
        'token' => $token
    ], 201);
}

}
