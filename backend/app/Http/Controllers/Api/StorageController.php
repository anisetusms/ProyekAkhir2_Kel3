<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\HttpFoundation\Response;

class StorageController extends Controller
{
    /**
     * Serve files from storage
     * 
     * @param string $path
     * @return \Illuminate\Http\Response
     */
    public function show($path)
    {
        // Decode the path to handle slashes
        $path = urldecode($path);
        
        // Log the requested path for debugging
        \Log::info("Storage access requested for: $path");
        
        // Check if file exists in storage
        if (!Storage::disk('public')->exists($path)) {
            \Log::warning("File not found in storage: $path");
            return response()->json([
                'status' => 'error',
                'message' => 'File not found'
            ], 404);
        }
        
        // Get file content
        $file = Storage::disk('public')->get($path);
        $type = Storage::disk('public')->mimeType($path);
        
        // Return file with appropriate headers
        return response($file, 200)->header('Content-Type', $type);
    }
}
