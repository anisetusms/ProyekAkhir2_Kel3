<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class RecentSearchController extends Controller
{
    public function index()
{
    $recent = RecentSearch::orderBy('created_at', 'desc')
                ->when(auth()->check(), fn($q) => $q->where('user_id', auth()->id()))
                ->limit(10)
                ->get();

    return response()->json($recent);
}
}
