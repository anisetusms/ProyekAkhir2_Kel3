<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\UserRole;
class RoleController extends Controller
{
    public function index()
    {
        $roles = UserRole::all(['id', 'name']);

        return response()->json([
            'data' => $roles
        ]);
    }
}
