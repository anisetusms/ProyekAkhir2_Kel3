<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\PropertyApiController;
use App\Http\Controllers\Api\PropertyPenywaApiController;
use App\Http\Controllers\Api\RoomPenywaApiController;
use App\Http\Controllers\Api\RoomApiController;
use App\Http\Controllers\Api\DashboardApiController;
use App\Http\Controllers\Api\CustomerDashboardController;
use App\Http\Controllers\Api\WishlistController;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\HttpFoundation\Response;
use App\Http\Controllers\Api\RoleController;
use App\Http\Controllers\Api\SettingController;

/*
|---------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
| Here is where you can register API routes for your application.
| These routes are loaded by the RouteServiceProvider within a group
| which is assigned the "api" middleware group. Enjoy building your API!
|
*/

// Authentication Routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Route to serve images from storage
Route::get('/storage/properties/{filename}', function ($filename) {
    $path = 'public/properties/' . $filename; 
    if (Storage::exists($path)) {
        return Storage::response($path);
    }
    return response('', Response::HTTP_NOT_FOUND);
})->where('filename', '.*');

// Property Routes
Route::get('/properties/{propertyId}/rooms', [RoomPenywaApiController::class, 'index']);
Route::get('/propertiesdetail/{id}', [PropertyPenywaApiController::class, 'show'])->name('api.properties.show');
Route::get('/roles', [RoleController::class, 'index']);

// Routes Protected by Sanctum Authentication
Route::middleware('auth:sanctum')->group(function () {
    
    // Profile Routes
    Route::get('/profile', [SettingController::class, 'profile']);  // Fetch Profile
    Route::post('/profile', [SettingController::class, 'updateProfile'])->name('api.profile.update');  // Update Profile
    Route::post('/profile/upload-picture', [SettingController::class, 'uploadProfilePicture']);  // Upload Profile Picture
    Route::post('/update-password', [SettingController::class, 'updatePassword']);  // Update Password

    // User Routes
    Route::get('/user', function (Request $request) { return $request->user(); });
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']); // Endpoint for logged-in user info

    // Property Routes
    Route::get('properties/available', [PropertyApiController::class, 'getAvailableProperties']);
    Route::get('/properties', [PropertyApiController::class, 'index'])->name('api.properties.index');
    Route::post('/properties', [PropertyApiController::class, 'store'])->name('api.properties.store');
    Route::get('/properties/{id}', [PropertyApiController::class, 'show'])->name('api.properties.show');
    Route::post('/properties/{id}', [PropertyApiController::class, 'update'])->name('api.properties.update');
    Route::delete('/properties/{id}', [PropertyApiController::class, 'destroy'])->name('api.properties.destroy');

    // Location Routes
    Route::get('/provinces', [PropertyApiController::class, 'getProvinces'])->name('api.provinces');
    Route::get('/cities/{provinceId}', [PropertyApiController::class, 'getCities'])->name('api.cities');
    Route::get('/districts/{cityId}', [PropertyApiController::class, 'getDistricts'])->name('api.districts');
    Route::get('/subdistricts/{districtId}', [PropertyApiController::class, 'getSubdistricts'])->name('api.subdistricts');

    // Dashboard Routes
    Route::get('/dashboard', [DashboardApiController::class, 'index'])->name('api.dashboard');
    Route::get('/dashboardc', [CustomerDashboardController::class, 'dashboardc']);

    // Room Routes for Property
    Route::prefix('properties/{property}/rooms')->name('api.properties.rooms.')->group(function () {
        Route::get('/', [RoomApiController::class, 'index'])->name('index');
        Route::post('/', [RoomApiController::class, 'store'])->name('store');
        Route::get('/{room}', [RoomApiController::class, 'show'])->name('show');
        Route::post('/{room}', [RoomApiController::class, 'update'])->name('update');
        Route::delete('/{room}', [RoomApiController::class, 'destroy'])->name('destroy');
        Route::post('/{room}/facilities', [RoomApiController::class, 'addFacility'])->name('facilities.store');
    });

    // Wishlist Routes
    Route::prefix('wishlist')->group(function () {
        Route::post('/toggle/{property}', [WishlistController::class, 'toggleWishlist']);
        Route::get('/check/{property}', [WishlistController::class, 'checkWishlist']);
        Route::get('/user', [WishlistController::class, 'getUserWishlists']);
    });
});
