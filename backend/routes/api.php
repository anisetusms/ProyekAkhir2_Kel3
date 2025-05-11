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
use App\Http\Controllers\Api\BookingController;
use App\Http\Controllers\Api\RoomController;
use App\Http\Controllers\Api\AdminBookingController;
use App\Http\Controllers\Api\NotificationController;

/*
|---------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
| Here is where you can register API routes for your application.
| These routes are loaded by the RouteServiceProvider within a group
| which is assigned the "api" middleware group. Enjoy building your API!
|
*/

// Route::middleware('auth:sanctum')->group(function () {
//     Route::get('/profile', [SettingController::class, 'profile']);
//     Route::put('/profile', [SettingController::class, 'updateProfile']); // Ini yang penting
//     Route::post('/profile/upload-picture', [SettingController::class, 'uploadProfilePicture']);
// });

// Route::get('/propertiescustomer', [PropertyPenywaApiController::class, 'index']);
// Route::get('/properties/{propertyId}/rooms', [RoomPenywaApiController::class, 'index']);
// Route::get('/propertiesdetail/{id}', [PropertyPenywaApiController::class, 'show'])->name('api.properties.show');
// Route::get('/roles', [RoleController::class, 'index']);

// // Authentication Routes
// Route::post('/register', [AuthController::class, 'register']);
// Route::post('/login', [AuthController::class, 'login']);

// // Route to serve images from storage
// Route::get('/storage/properties/{filename}', function ($filename) {
//     $path = 'public/properties/' . $filename;
//     if (Storage::exists($path)) {
//         return Storage::response($path);
//     }
//     return response('', Response::HTTP_NOT_FOUND);
// })->where('filename', '.*');

// // Property Routes
// Route::get('/properties/{propertyId}/rooms', [RoomPenywaApiController::class, 'index']);
// Route::get('/propertiesdetail/{id}', [PropertyPenywaApiController::class, 'show'])->name('api.properties.show');
// Route::get('/roles', [RoleController::class, 'index']);

// // Routes Protected by Sanctum Authentication
// Route::middleware('auth:sanctum')->group(function () {

//     // Profile Routes
//     Route::get('/profile', [SettingController::class, 'profile']);  // Fetch Profile
//     Route::post('/profile', [SettingController::class, 'updateProfile'])->name('api.profile.update');  // Update Profile
//     Route::post('/profile/upload-picture', [SettingController::class, 'uploadProfilePicture']);  // Upload Profile Picture
//     Route::post('/update-password', [SettingController::class, 'updatePassword']);  // Update Password

//     // User Routes
//     Route::get('/user', function (Request $request) {
//         return $request->user();
//     });
//     Route::post('/logout', [AuthController::class, 'logout']);
//     Route::get('/me', [AuthController::class, 'me']); // Endpoint for logged-in user info

//     // Property Routes
//     Route::get('properties/available', [PropertyApiController::class, 'getAvailableProperties']);
//     Route::get('/properties', [PropertyApiController::class, 'index'])->name('api.properties.index');
//     Route::post('/properties', [PropertyApiController::class, 'store'])->name('api.properties.store');
//     Route::get('/properties/{id}', [PropertyApiController::class, 'show'])->name('api.properties.show');
//     Route::post('/properties/{id}', [PropertyApiController::class, 'update'])->name('api.properties.update');
//     Route::delete('/properties/{id}', [PropertyApiController::class, 'destroy'])->name('api.properties.destroy');
//     Route::get('/property/search', [PropertyPenywaApiController::class, 'search']);
//     //mengambil property yang dinonaktifkan juga
//     Route::get('/properties/all', [PropertyApiController::class, 'getAllProperties'])->name('api.properties.all'); // Tambahkan endpoint baru
//     // Tambahkan rute untuk mengaktifkan/menonaktifkan properti
//     Route::post('/properties/{id}/deactivate', [PropertyApiController::class, 'deactivate'])->name('api.properties.deactivate');
//     Route::post('/properties/{id}/reactivate', [PropertyApiController::class, 'reactivate'])->name('api.properties.reactivate');

//     // Route::prefix('properties/{property}/rooms')->name('api.properties.rooms.')->group(function () {
//     //     Route::get('/', [RoomController::class, 'index'])->name('index');
//     //     Route::post('/', [RoomController::class, 'store'])->name('store');
//     //     Route::get('/{room}', [RoomController::class, 'show'])->name('show');
//     //     Route::post('/{room}', [RoomController::class, 'update'])->name('update');
//     //     Route::delete('/{room}', [RoomController::class, 'destroy'])->name('destroy');
//     //     Route::post('/{room}/facilities', [RoomController::class, 'addFacility'])->name('facilities.store');
//     // });

//     Route::prefix('properties/{property}/rooms')->name('api.properties.rooms.')->group(function () {
//         Route::get('/', [RoomController::class, 'index']); // Menampilkan daftar kamar untuk penyewa
//         Route::get('/{room}', [RoomController::class, 'show']); // Menampilkan detail kamar untuk penyewa
//     });

//     // Location Routes
//     Route::get('/provinces', [PropertyApiController::class, 'getProvinces'])->name('api.provinces');
//     Route::get('/cities/{provinceId}', [PropertyApiController::class, 'getCities'])->name('api.cities');
//     Route::get('/districts/{cityId}', [PropertyApiController::class, 'getDistricts'])->name('api.districts');
//     Route::get('/subdistricts/{districtId}', [PropertyApiController::class, 'getSubdistricts'])->name('api.subdistricts');

//     // Dashboard Routes
//     Route::get('/dashboard', [DashboardApiController::class, 'index'])->name('api.dashboard');
//     Route::get('/dashboardc', [CustomerDashboardController::class, 'dashboardc']);

//     // Room Routes for Property
//     // Route::prefix('properties/{property}/rooms')->name('api.properties.rooms.')->group(function () {
//     //     Route::get('/', [RoomApiController::class, 'index'])->name('index');
//     //     Route::post('/', [RoomApiController::class, 'store'])->name('store');
//     //     Route::get('/{room}', [RoomApiController::class, 'show'])->name('show');
//     //     Route::post('/{room}', [RoomApiController::class, 'update'])->name('update');
//     //     Route::delete('/{room}', [RoomApiController::class, 'destroy'])->name('destroy');
//     //     Route::post('/{room}/facilities', [RoomApiController::class, 'addFacility'])->name('facilities.store');
//     // });
//     Route::prefix('admin')->group(function () {
//         Route::get('/properties/{propertyId}/rooms', [RoomController::class, 'index']); // Menampilkan daftar kamar
//         Route::get('/properties/{propertyId}/rooms/{roomId}', [RoomController::class, 'show']); // Menampilkan detail kamar
//         Route::post('/properties/{propertyId}/rooms', [RoomController::class, 'store']); // Menambahkan kamar baru
//         Route::post('/properties/{propertyId}/rooms/{roomId}', [RoomController::class, 'update']); // Memperbarui kamar
//         Route::delete('/properties/{propertyId}/rooms/{roomId}', [RoomController::class, 'destroy']); // Menghapus kamar
//     });


//     // Route::prefix('bookings')->group(function () {
//     //     Route::get('/', [BookingController::class, 'index']);
//     //     Route::post('/', [BookingController::class, 'store']);
//     //     Route::get('/{id}', [BookingController::class, 'show']);
//     //     Route::put('/{id}/cancel', [BookingController::class, 'cancel']);
//     // });

//     Route::post('/bookings/check-availability', [BookingController::class, 'checkAvailability']);
//     Route::get('/bookings', [BookingController::class, 'index']);
//     Route::post('/bookings', [BookingController::class, 'store']);
//     Route::get('/bookings/{id}', [BookingController::class, 'show']);
//     Route::put('/bookings/{id}/cancel', [BookingController::class, 'cancel']);
//     Route::post('/bookings/{id}/payment-proof', [BookingController::class, 'uploadPaymentProof']);

//     // Wishlist Routes
//     Route::prefix('wishlist')->group(function () {
//         Route::post('/toggle/{property}', [WishlistController::class, 'toggleWishlist']);
//         Route::get('/check/{property}', [WishlistController::class, 'checkWishlist']);
//         Route::get('/user', [WishlistController::class, 'getUserWishlists']);
//     });
// });

/*
|---------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
| Here is where you can register API routes for your application.
| These routes are loaded by the RouteServiceProvider within a group
| which is assigned the "api" middleware group. Enjoy building your API!
|
*/







Route::middleware('auth:sanctum')->group(function () {
    // Notification routes
    Route::prefix('notifications')->group(function () {
        Route::get('/', [NotificationController::class, 'index']);
        Route::get('/unread-count', [NotificationController::class, 'getUnreadCount']);
        Route::post('/{id}/mark-as-read', [NotificationController::class, 'markAsRead']);
        Route::post('/mark-all-as-read', [NotificationController::class, 'markAllAsRead']);
        Route::delete('/{id}', [NotificationController::class, 'destroy']);
    });
});

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/profile', [SettingController::class, 'profile']);
    Route::put('/profile', [SettingController::class, 'updateProfile']); // Ini yang penting
    Route::post('/profile', [SettingController::class, 'updateProfile'])->name('api.profile.update');
    Route::post('/profile/upload-picture', [SettingController::class, 'uploadProfilePicture']);
});

Route::get('/propertiescustomer', [PropertyPenywaApiController::class, 'index']);
Route::get('/properties/{propertyId}/rooms', [RoomPenywaApiController::class, 'index']);
Route::get('/propertiesdetail/{id}', [PropertyPenywaApiController::class, 'show'])->name('api.properties.show');
Route::get('/roles', [RoleController::class, 'index']);

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
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']); // Endpoint for logged-in user info

    // Property Routes
    Route::get('properties/available', [PropertyApiController::class, 'getAvailableProperties']);
    Route::get('/properties', [PropertyApiController::class, 'index'])->name('api.properties.index');
    Route::get('/properties/all', [PropertyApiController::class, 'getAllProperties'])->name('api.properties.all'); // Tambahkan endpoint baru
    Route::post('/properties', [PropertyApiController::class, 'store'])->name('api.properties.store');
    Route::get('/properties/{id}', [PropertyApiController::class, 'show'])->name('api.properties.show');
    Route::post('/properties/{id}', [PropertyApiController::class, 'update'])->name('api.properties.update');

    // Tambahkan rute untuk mengaktifkan/menonaktifkan properti
    Route::post('/properties/{id}/deactivate', [PropertyApiController::class, 'deactivate'])->name('api.properties.deactivate');
    Route::post('/properties/{id}/reactivate', [PropertyApiController::class, 'reactivate'])->name('api.properties.reactivate');

    Route::get('/property/search', [PropertyPenywaApiController::class, 'search']);

    // Route::prefix('properties/{property}/rooms')->name('api.properties.rooms.')->group(function () {
    //     Route::get('/', [RoomController::class, 'index'])->name('index');
    //     Route::post('/', [RoomController::class, 'store'])->name('store');
    //     Route::get('/{room}', [RoomController::class, 'show'])->name('show');
    //     Route::post('/{room}', [RoomController::class, 'update'])->name('update');
    //     Route::delete('/{room}', [RoomController::class, 'destroy'])->name('destroy');
    //     Route::post('/{room}/facilities', [RoomController::class, 'addFacility'])->name('facilities.store');
    // });

    Route::prefix('properties/{property}/rooms')->name('api.properties.rooms.')->group(function () {
        Route::get('/', [RoomController::class, 'index']); // Menampilkan daftar kamar untuk penyewa
        Route::get('/{room}', [RoomController::class, 'show']); // Menampilkan detail kamar untuk penyewa
    });

    // Location Routes
    Route::get('/provinces', [PropertyApiController::class, 'getProvinces'])->name('api.provinces');
    Route::get('/cities/{provinceId}', [PropertyApiController::class, 'getCities'])->name('api.cities');
    Route::get('/districts/{cityId}', [PropertyApiController::class, 'getDistricts'])->name('api.districts');
    Route::get('/subdistricts/{districtId}', [PropertyApiController::class, 'getSubdistricts'])->name('api.subdistricts');

    // Dashboard Routes
    Route::get('/dashboard', [DashboardApiController::class, 'index'])->name('api.dashboard');
    Route::get('/dashboardc', [CustomerDashboardController::class, 'dashboardc']);

    // Room Routes for Property
    // Route::prefix('properties/{property}/rooms')->name('api.properties.rooms.')->group(function () {
    //     Route::get('/', [RoomApiController::class, 'index'])->name('index');
    //     Route::post('/', [RoomApiController::class, 'store'])->name('store');
    //     Route::get('/{room}', [RoomApiController::class, 'show'])->name('show');
    //     Route::post('/{room}', [RoomApiController::class, 'update'])->name('update');
    //     Route::delete('/{room}', [RoomApiController::class, 'destroy'])->name('destroy');
    //     Route::post('/{room}/facilities', [RoomApiController::class, 'addFacility'])->name('facilities.store');
    // });
    Route::prefix('admin')->group(function () {
        Route::get('/properties/{propertyId}/rooms', [RoomController::class, 'index']); // Menampilkan daftar kamar
        Route::get('/properties/{propertyId}/rooms/{roomId}', [RoomController::class, 'show']); // Menampilkan detail kamar
        Route::post('/properties/{propertyId}/rooms', [RoomController::class, 'store']); // Menambahkan kamar baru
        Route::post('/properties/{propertyId}/rooms/{roomId}', [RoomController::class, 'update']); // Memperbarui kamar
        Route::delete('/properties/{propertyId}/rooms/{roomId}', [RoomController::class, 'destroy']); // Menghapus kamar
    });

    //     // Room Routes for Property
    Route::prefix('properties/{property}/rooms')->name('api.properties.rooms.')->group(function () {
        Route::get('/', [RoomApiController::class, 'index'])->name('index');
        Route::post('/', [RoomApiController::class, 'store'])->name('store');
        Route::get('/{room}', [RoomApiController::class, 'show'])->name('show');
        Route::post('/{room}', [RoomApiController::class, 'update'])->name('update');
        Route::delete('/{room}', [RoomApiController::class, 'destroy'])->name('destroy');
        Route::post('/{room}/facilities', [RoomApiController::class, 'addFacility'])->name('facilities.store');
    });


    // // Customer Booking Routes
    // Route::post('/bookings/check-availability', [BookingController::class, 'checkAvailability']);
    // Route::get('/bookings', [BookingController::class, 'index']);
    // Route::post('/bookings', [BookingController::class, 'store']);
    // Route::get('/bookings/{id}', [BookingController::class, 'show']);
    // Route::put('/bookings/{id}/cancel', [BookingController::class, 'cancel']);
    // Route::post('/bookings/{id}/payment-proof', [BookingController::class, 'uploadPaymentProof']);

    // Admin Booking Routes
    Route::prefix('admin/bookings')->group(function () {
        Route::get('/', [AdminBookingController::class, 'index']);
        Route::get('/statistics', [AdminBookingController::class, 'statistics']);
        Route::get('/{id}', [AdminBookingController::class, 'show']);
        Route::post('/{id}/confirm', [AdminBookingController::class, 'confirm']);
        Route::post('/{id}/reject', [AdminBookingController::class, 'reject']);
        Route::post('/{id}/complete', [AdminBookingController::class, 'complete']);
    });


    // Route::prefix('bookings')->group(function () {
    //     Route::get('/', [BookingController::class, 'index']);
    //     Route::post('/', [BookingController::class, 'store']);
    //     Route::get('/{id}', [BookingController::class, 'show']);
    //     Route::put('/{id}/cancel', [BookingController::class, 'cancel']);
    // });

    Route::post('/bookings/check-availability', [BookingController::class, 'checkAvailability']);
    Route::get('/bookings', [BookingController::class, 'index']);
    Route::post('/bookings', [BookingController::class, 'store']);
    Route::get('/bookings/{id}', [BookingController::class, 'show']);
    Route::put('/bookings/{id}/cancel', [BookingController::class, 'cancel']);
    Route::post('/bookings/{id}/payment-proof', [BookingController::class, 'uploadPaymentProof']);

    // Wishlist Routes
    Route::prefix('wishlist')->group(function () {
        Route::post('/toggle/{property}', [WishlistController::class, 'toggleWishlist']);
        Route::get('/check/{property}', [WishlistController::class, 'checkWishlist']);
        Route::get('/user', [WishlistController::class, 'getUserWishlists']);
    });
});
