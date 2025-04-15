<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
// routes/api.php
use App\Http\Controllers\API\PropertyController;
use App\Http\Controllers\API\RoomController;

Route::middleware('auth:sanctum')->group(function () {
    // Property routes
    Route::get('/properties', [PropertyController::class, 'index']);
    Route::post('/properties', [PropertyController::class, 'store']);
    Route::get('/properties/{id}', [PropertyController::class, 'show']);
    Route::put('/properties/{id}', [PropertyController::class, 'update']);
    Route::delete('/properties/{id}', [PropertyController::class, 'destroy']);

    // Room routes
    Route::get('/properties/{propertyId}/rooms', [RoomController::class, 'index']);
    Route::post('/properties/{propertyId}/rooms', [RoomController::class, 'store']);
    Route::put('/properties/{propertyId}/rooms/{roomId}', [RoomController::class, 'update']);
    Route::delete('/properties/{propertyId}/rooms/{roomId}', [RoomController::class, 'destroy']);
});