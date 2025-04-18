<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
// routes/api.php
use App\Http\Controllers\API\PropertyApiController;
use App\Http\Controllers\API\RoomController;

Route::middleware('auth:sanctum')->group(function () {
    // Property endpoints
    Route::get('/properties', [PropertyApiController::class, 'index']);
    Route::get('/properties/{id}', [PropertyApiController::class, 'show']);
    Route::post('/properties', [PropertyApiController::class, 'store']);
    Route::put('/properties/{id}', [PropertyApiController::class, 'update']);
    Route::delete('/properties/{id}', [PropertyApiController::class, 'destroy']);
    
    // Location endpoints
    Route::get('/locations/cities/{provinceId}', [PropertyApiController::class, 'getCities']);
    Route::get('/locations/districts/{cityId}', [PropertyApiController::class, 'getDistricts']);
    Route::get('/locations/subdistricts/{districtId}', [PropertyApiController::class, 'getSubdistricts']);
    
    // Dashboard data
    Route::get('/dashboard', [PropertyApiController::class, 'dashboard']);
});