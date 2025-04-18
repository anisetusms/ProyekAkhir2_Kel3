<?php

use App\Http\Controllers\Admin\PropertyController;
use App\Http\Controllers\Admin\RoomController;
use App\Http\Controllers\Admin\UnitController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\LocationController;
use App\Http\Controllers\OwnerController;
use App\Http\Controllers\PlatformAdminController;
use App\Http\Controllers\SuperAdminController;
use App\Http\Controllers\UserController;
use App\Models\Property;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Route;
use App\Models\User;
use App\Http\Controllers\Admin\SettingController;
use App\Http\Controllers\SettingControllerS;
use App\Http\Controllers\SettingControllerP;


// Landing Page
Route::get('/', [AuthController::class, 'landingpage'])->name('landingpage');

// Authentication Routes
Route::get('/login', [AuthController::class, 'showLoginForm'])->name('showLoginForm');
Route::post('/login1', [AuthController::class, 'login'])->name('login1');
Route::post('/logout', [AuthController::class, 'logout'])->name('logout');


// Registration
Route::get('/register', [AuthController::class, 'showRegisterForm'])->name('register');
Route::post('/register-insert', [AuthController::class, 'insertRegister'])->name('insertRegister');

// Detail Property
Route::get('/detail-property/{id}', [UserController::class, 'showDetailProperty'])->name('detail-property.show');

// User Type and Role
Route::post('/userType-insert', [AuthController::class, 'insertUserType'])->name('insertUserType');
Route::get('/userRole-insert', [AuthController::class, 'insertUserRole'])->name('insertUserRole');

// Owner Routes
Route::prefix('owner')->name('owner.')->group(function () {
    Route::get('/dashboard-owner', [OwnerController::class, 'dashboard_owner'])->name('dashboard');
    Route::get('/property', [OwnerController::class, 'showPropertypage'])->name('property');
    Route::get('/add-property', [OwnerController::class, 'add_property'])->name('add-property');
    Route::post('/store_property', [OwnerController::class, 'store_property'])->name('store_property');
    Route::get('/edit-property/{id}', [OwnerController::class, 'edit_property'])->name('edit-property');
    Route::post('/update-property/{id}', [OwnerController::class, 'update_property'])->name('update-property');
    Route::delete('/delete-property/{id}', [OwnerController::class, 'delete_property'])->name('delete-property');
    Route::get('get-cities/{provinceId}', [OwnerController::class, 'getCities']);
    Route::post('/provinces', [OwnerController::class, 'storeProvinces']);
    Route::post('/cities', [OwnerController::class, 'storeCities']);
    Route::post('/districts', [OwnerController::class, 'storeDistricts']);
    Route::post('/subdistricts', [OwnerController::class, 'storeSubdistricts']);
    Route::get('/provinces', [OwnerController::class, 'getProvinces']);
    // Route::get('/get-districts/{city}', [OwnerController::class, 'getDistricts']);
    // Route::get('/get-subdistricts/{district}', [OwnerController::class, 'getSubdistricts']);
    // Location APIs
    Route::get('/get-cities/{provinceId}', [OwnerController::class, 'getCities']);
    Route::get('/get-districts/{cityId}', [OwnerController::class, 'getDistricts']);
    Route::get('/get-subdistricts/{districtId}', [OwnerController::class, 'getSubdistricts']);
    // Rute untuk menampilkan halaman edit properti
    Route::get('/edit-property/{id}', [OwnerController::class, 'editProperty'])->name('edit-property');

    // Rute untuk menyimpan perubahan properti
    Route::put('/update-property/{id}', [OwnerController::class, 'updateProperty'])->name('update-property');
});


// Location Routes
// Route::prefix('location')->group(function () {
//     Route::get('/cities/{provinceId}', [LocationController::class, 'getCities']);
//     Route::get('/districts/{cityId}', [LocationController::class, 'getDistricts']);
//     Route::get('/subdistricts/{districtId}', [LocationController::class, 'getSubdistricts']);
// });


// Super Admin Routes
Route::prefix('super-admin')->name('super_admin.')->group(function () {
    Route::get('/dashboard', [SuperAdminController::class, 'dashboard'])->name('dashboard');
    Route::get('/settings', [SettingControllerS::class, 'index'])->name('settings');
    Route::put('/settings/profile', [SettingControllerS::class, 'updateProfile'])->name('settings.profile.update');
    Route::put('/settings/password', [SettingControllerS::class, 'updatePassword'])->name('settings.password.update');

    // Route untuk melihat profil Super Admin
    Route::get('/profiles', [SuperAdminController::class, 'showProfile'])->name('profiles.index');

    // Route untuk memperbarui profil Super Admin
    Route::put('/profiles/update', [SuperAdminController::class, 'updateProfile'])->name('profiles.update');
    Route::get('/profiles/edit', [SuperAdminController::class, 'editProfile'])->name('profiles.edit'); // Route untuk edit profil

    // Manage Entrepreneurs
    Route::prefix('entrepreneurs')->name('entrepreneurs.')->group(function () {
        Route::get('/', [SuperAdminController::class, 'manageEntrepreneurs'])->name('index');
        Route::get('/create', [SuperAdminController::class, 'addEntrepreneur'])->name('create');
        Route::post('/store', [SuperAdminController::class, 'storeEntrepreneur'])->name('store');
        Route::post('/delete', [SuperAdminController::class, 'deleteEntrepreneur'])->name('delete');
        Route::get('/edit/{id}', [SuperAdminController::class, 'editEntrepreneur'])->name('edit');
        Route::post('/update/{id}', [SuperAdminController::class, 'updateEntrepreneur'])->name('update');
        Route::get('/destroy/{id}', [SuperAdminController::class, 'destroyEntrepreneur'])->name('destroy');
    });

    // Manage Platform Admins
    Route::prefix('platform-admins')->name('platform_admins.')->group(function () {
        Route::get('/', [SuperAdminController::class, 'managePlatformAdmins'])->name('index');
        Route::get('/create', [SuperAdminController::class, 'createPlatformAdmin'])->name('create');
        Route::post('/store', [SuperAdminController::class, 'storePlatformAdmin'])->name('store');
        Route::get('/edit/{id}', [SuperAdminController::class, 'editPlatformAdmin'])->name('edit');
        Route::put('/update/{id}', [SuperAdminController::class, 'updatePlatformAdmin'])->name('update');
        Route::delete('/delete/{id}', [SuperAdminController::class, 'deletePlatformAdmin'])->name('delete');
    });
});

// Platform Admin Routes
Route::prefix('platform-admin')->name('platform_admin.')->group(function () {
    Route::get('/settings', [SettingControllerP::class, 'index'])->name('settings');
    Route::put('/settings/profile', [SettingControllerP::class, 'updateProfile'])->name('settings.profile.update');
    Route::put('/settings/password', [SettingControllerP::class, 'updatePassword'])->name('settings.password.update');
    Route::get('/dashboard', [PlatformAdminController::class, 'dashboard'])->name('dashboard');
    Route::get('/pengusaha', [PlatformAdminController::class, 'pengusaha'])->name('pengusaha');
    Route::get('/penyewa', [PlatformAdminController::class, 'penyewa'])->name('penyewa');
    Route::get('/', [PlatformAdminController::class, 'index'])->name('index');
    Route::post('/ban/{id}', [PlatformAdminController::class, 'ban'])->name('ban');
    Route::post('/unban/{id}', [PlatformAdminController::class, 'unban'])->name('unban');
    Route::get('/profil', [PlatformAdminController::class, 'profil'])->name('profil');
    Route::put('/profil', [PlatformAdminController::class, 'updateProfil'])->name('update_profil');
});

Route::prefix('admin')->name('admin.')->group(function () {
    Route::get('/settings', [SettingController::class, 'index'])->name('settings');
    Route::put('/settings/profile', [SettingController::class, 'updateProfile'])->name('settings.profile.update');
    Route::put('/settings/password', [SettingController::class, 'updatePassword'])->name('settings.password.update');
    Route::get('/properties/dashboard', [PropertyController::class, 'dashboard'])->name('properties.dashboard');
    Route::get('/properties', [PropertyController::class, 'index'])->name('properties.index');
    Route::get('/properties/rooms', [PropertyController::class, 'index'])->name('properties.rooms.index');
    Route::get('/rooms', [PropertyController::class, 'index'])->name('rooms.index');
    Route::get('/properties/create', [PropertyController::class, 'create'])->name('properties.create');
    Route::post('/properties', [PropertyController::class, 'store'])->name('properties.store');
    Route::get('/properties/{id}', [PropertyController::class, 'show'])->name('properties.show');
    Route::get('/properties/{id}/edit', [PropertyController::class, 'edit'])->name('properties.edit');
    Route::put('/properties/{id}', [PropertyController::class, 'update'])->name('properties.update');
    Route::delete('/properties/{id}', [PropertyController::class, 'destroy'])->name('properties.destroy');
    // Route::post('/provinces', [OwnerController::class, 'storeProvinces']);
    // Route::post('/cities', [OwnerController::class, 'storeCities']);
    // Route::post('/districts', [OwnerController::class, 'storeDistricts']);
    // Route::post('/subdistricts', [OwnerController::class, 'storeSubdistricts']);
    // Route::get('properties/{property}/rooms/create', [RoomController::class, 'create'])->name('properties.rooms.create');
    // Route::post('properties/{property}/rooms', [RoomController::class, 'store'])->name('properties.rooms.store');
    // Route::get('properties/{property}/units/create', [UnitController::class, 'create'])->name('properties.units.create');
    // Route::post('properties/{property}/units', [UnitController::class, 'store'])->name('properties.units.store');
    Route::prefix('properties/{property}/rooms')->name('properties.rooms.')->group(function () {
        Route::get('/', [RoomController::class, 'index'])->name('index');
        Route::get('/create', [RoomController::class, 'create'])->name('create');
        Route::post('/', [RoomController::class, 'store'])->name('store');
        Route::get('/{room}/edit', [RoomController::class, 'edit'])->name('edit');
        Route::put('/{room}', [RoomController::class, 'update'])->name('update');
        Route::delete('/{room}', [RoomController::class, 'destroy'])->name('destroy');
    });
});

Route::prefix('admin/properties')->name('admin.properties.')->group(function () {
    Route::get('cities/{province_id}', [PropertyController::class, 'getCities'])->name('cities');
    Route::get('districts/{city_id}', [PropertyController::class, 'getDistricts'])->name('districts');
    Route::get('subdistricts/{district_id}', [PropertyController::class, 'getSubdistricts'])->name('subdistricts');
});

// Route::middleware(['auth', 'verified'])->prefix('admin')->name('admin.')->group(function () {
//     // Property routes
//     Route::get('/properties', [PropertyController::class, 'index'])->name('properties.index');
//     Route::get('/properties/create', [PropertyController::class, 'create'])->name('properties.create');
//     Route::post('/properties', [PropertyController::class, 'store'])->name('properties.store');
//     Route::get('/properties/{id}', [PropertyController::class, 'show'])->name('properties.show');
//     Route::get('/properties/{id}/edit', [PropertyController::class, 'edit'])->name('properties.edit');
//     Route::put('/properties/{id}', [PropertyController::class, 'update'])->name('properties.update');
//     Route::delete('/properties/{id}', [PropertyController::class, 'destroy'])->name('properties.destroy');

//     // AJAX routes for location
//     Route::get('/properties/cities/{province_id}', [PropertyController::class, 'getCities'])->name('properties.cities');
//     Route::get('/properties/districts/{city_id}', [PropertyController::class, 'getDistricts'])->name('properties.districts');
//     Route::get('/properties/subdistricts/{district_id}', [PropertyController::class, 'getSubdistricts'])->name('properties.subdistricts');

//     // Room routes
//     Route::get('/properties/{propertyId}/rooms', [RoomController::class, 'index'])->name('properties.rooms.index');
//     Route::get('/properties/{propertyId}/rooms/create', [RoomController::class, 'create'])->name('properties.rooms.create');
//     Route::post('/properties/{propertyId}/rooms', [RoomController::class, 'store'])->name('properties.rooms.store');
//     Route::get('/properties/{propertyId}/rooms/{roomId}', [RoomController::class, 'show'])->name('properties.rooms.show');
//     Route::get('/properties/{propertyId}/rooms/{roomId}/edit', [RoomController::class, 'edit'])->name('properties.rooms.edit');
//     Route::put('/properties/{propertyId}/rooms/{roomId}', [RoomController::class, 'update'])->name('properties.rooms.update');
//     Route::delete('/properties/{propertyId}/rooms/{roomId}', [RoomController::class, 'destroy'])->name('properties.rooms.destroy');
// });
