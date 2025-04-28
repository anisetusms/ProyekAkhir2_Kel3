<?php
namespace App\Http\Controllers\Api;
use App\Http\Controllers\Controller;
use App\Models\Property;
use Illuminate\Http\Request;

class CustomerDashboardController extends Controller
{
    public function dashboardc(Request $request)
    {
        // Ambil 5 properti terbaru beserta relasi yang dibutuhkan
        $latestProperties = Property::with(['district', 'subdistrict','propertytype'])
            ->orderBy('created_at', 'desc')
            ->limit(5)
            ->get();

        // Format response hanya menampilkan data yang dibutuhkan
        $latestProperties = $latestProperties->map(function ($property) {
            return [
                'id' => $property->id,
                'name' => $property->name,
                'propertytype' => $property->propertytype?->name,
                'address' => $property->address,
                'price' => $property->price,
                'district' => $property->district?->dis_name ?? 'Unknown',
                'subdistrict' => $property->subdistrict?->subdis_name ?? 'Unknown',
                'image' => $property->image_url,
                'created_at' => $property->created_at->format('Y-m-d H:i:s'),
            ];
        });

        return response()->json([
            'latest_properties' => $latestProperties
        ]);
    }
}
