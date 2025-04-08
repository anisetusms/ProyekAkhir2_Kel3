<?php

namespace App\Http\Controllers\Auth;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use App\Http\Controllers\Controller;
use App\Models\User;
use Carbon\Carbon;

class EmailVerificationController extends Controller
{
    // Fungsi untuk menangani verifikasi email dari link
    public function verify($id, $token)
    {
        $user = User::find($id);

        if (!$user || $user->email_verified_at || !hash_equals(sha1($user->email), $token)) {
            return redirect('/login')->with('error', 'Link verifikasi tidak valid atau sudah digunakan.');
        }

        // Update kolom email_verified_at
        DB::table('users')->where('id', $id)->update([
            'email_verified_at' => Carbon::now()
        ]);

        return redirect('/login')->with('success', 'Email berhasil diverifikasi, silakan login!');
    }

    // Fungsi untuk mengirim ulang email verifikasi
    public function resend(Request $request)
    {
        $user = User::where('email', $request->email)->first();

        if (!$user || $user->email_verified_at) {
            return back()->with('error', 'Email sudah diverifikasi atau tidak ditemukan.');
        }

        // Kirim ulang email verifikasi
        $this->sendVerificationEmail($user);

        return back()->with('success', 'Email verifikasi telah dikirim ulang.');
    }

    // Fungsi untuk mengirim email
    protected function sendVerificationEmail($user)
    {
        $verificationUrl = route('email.verify', ['id' => $user->id, 'token' => sha1($user->email)]);

        Mail::raw("Klik link ini untuk verifikasi email: $verificationUrl", function ($message) use ($user) {
            $message->to($user->email)
                ->subject('Verifikasi Email');
        });
    }
}

