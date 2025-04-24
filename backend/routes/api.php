<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\PropertyApiController;
use App\Http\Controllers\Api\DashboardApiController;
use App\Http\Controllers\Api\RoleController;
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::get('/roles', [RoleController::class, 'index']);

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// Authentication Routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Protected Routes (require Sanctum authentication)
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']); // Endpoint untuk mendapatkan informasi user yang login

    // Property Routes
    Route::get('/properties', [PropertyApiController::class, 'index']);
    Route::post('/properties', [PropertyApiController::class, 'store']);
    Route::get('/properties/{id}', [PropertyApiController::class, 'show']);
    Route::post('/properties/{id}', [PropertyApiController::class, 'update']); // Menggunakan POST untuk update agar sesuai Flutter
    Route::delete('/properties/{id}', [PropertyApiController::class, 'destroy']);

    // Location Routes
    Route::get('/provinces', [PropertyApiController::class, 'getProvinces']);
    Route::get('/cities/{provinceId}', [PropertyApiController::class, 'getCities']);
    Route::get('/districts/{cityId}', [PropertyApiController::class, 'getDistricts']);
    Route::get('/subdistricts/{districtId}', [PropertyApiController::class, 'getSubdistricts']);

    // Dashboard Route
    Route::get('/dashboard', [DashboardApiController::class, 'index']);
});