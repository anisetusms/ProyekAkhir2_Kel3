<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\PropertyApiController;
use App\Http\Controllers\Api\RoomApiController; // Pastikan controller ini ada
use App\Http\Controllers\Api\DashboardApiController;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\HttpFoundation\Response;
use App\Http\Controllers\Api\RoleController;
use App\Http\Controllers\Api\SettingController;
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

// Route to serve images from storage
Route::get('/storage/properties/{filename}', function ($filename) {
    $path = 'public/properties/' . $filename; // Adjust path if needed
    if (Storage::exists($path)) {
        return Storage::response($path);
    }
    return response('', Response::HTTP_NOT_FOUND);
})->where('filename', '.*');

<<<<<<< Updated upstream
=======
Route::middleware('auth:sanctum')->get('/profile', [SettingController::class, 'profile']);

>>>>>>> Stashed changes
// Protected Routes (require Sanctum authentication)
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']); // Endpoint untuk mendapatkan informasi user yang login
    // Untuk memperbarui profil tanpa autentikasi (jika dibutuhkan)
    Route::post('/profile', [SettingController::class, 'updateProfile'])->name('api.profile.update');
    Route::get('/profile', [SettingController::class, 'profile']);
    Route::post('/profile', [SettingController::class, 'updateProfile']);
    Route::post('/update-password', [SettingController::class, 'updatePassword']);
    // Untuk mendapatkan profil (akses publik jika perlu)
    Route::get('/profile', [SettingController::class, 'profile'])->name('api.profile');

    // Property Routes
    Route::get('/properties', [PropertyApiController::class, 'index'])->name('api.properties.index');
    Route::post('/properties', [PropertyApiController::class, 'store'])->name('api.properties.store');
    Route::get('/properties/{id}', [PropertyApiController::class, 'show'])->name('api.properties.show');
    Route::post('/properties/{id}', [PropertyApiController::class, 'update'])->name('api.properties.update'); // Menggunakan POST untuk update agar sesuai Flutter
    Route::delete('/properties/{id}', [PropertyApiController::class, 'destroy'])->name('api.properties.destroy');

    // Location Routes
    Route::get('/provinces', [PropertyApiController::class, 'getProvinces'])->name('api.provinces');
    Route::get('/cities/{provinceId}', [PropertyApiController::class, 'getCities'])->name('api.cities');
    Route::get('/districts/{cityId}', [PropertyApiController::class, 'getDistricts'])->name('api.districts');
    Route::get('/subdistricts/{districtId}', [PropertyApiController::class, 'getSubdistricts'])->name('api.subdistricts');

    // Dashboard Route
    Route::get('/dashboard', [DashboardApiController::class, 'index'])->name('api.dashboard');

    // Room Routes under a specific Property
    Route::prefix('properties/{property}/rooms')->name('api.properties.rooms.')->group(function () {
        Route::get('/', [RoomApiController::class, 'index'])->name('index'); // Get all rooms for a property
        Route::post('/', [RoomApiController::class, 'store'])->name('store'); // Create a new room for a property
        Route::get('/{room}', [RoomApiController::class, 'show'])->name('show'); // Get a specific room
        Route::post('/{room}', [RoomApiController::class, 'update'])->name('update'); // Update a specific room (POST for Flutter)
        Route::delete('/{room}', [RoomApiController::class, 'destroy'])->name('destroy'); // Delete a specific room

        // Route for adding facilities to a specific room
        Route::post('/{room}/facilities', [RoomApiController::class, 'addFacility'])->name('facilities.store');
    });
<<<<<<< Updated upstream
});
=======

    Route::prefix('wishlist')->group(function () {
        Route::post('/toggle/{property}', [WishlistController::class, 'toggleWishlist']);
        Route::get('/check/{property}', [WishlistController::class, 'checkWishlist']);
        Route::get('/user', [WishlistController::class, 'getUserWishlists']);
    });
});
>>>>>>> Stashed changes
