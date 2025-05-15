<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Booking;
use App\Models\Room;
use App\Models\PropertyAvailability;
use Carbon\Carbon;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;

class UpdateBookingStatuses extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'bookings:update-statuses';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Update booking statuses based on check-in and check-out dates';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $this->info('Memulai pembaruan status booking...');
        Log::info('Memulai pembaruan status booking otomatis');
        
        try {
            DB::beginTransaction();
            
            // 1. Update bookings yang sudah melewati tanggal check-out menjadi completed
            $completedBookings = Booking::where('status', 'confirmed')
                ->where('check_out', '<', Carbon::now()->startOfDay())
                ->get();
                
            foreach ($completedBookings as $booking) {
                $booking->update(['status' => 'completed']);
                $this->info("Booking #{$booking->id} diubah menjadi completed");
                Log::info("Booking #{$booking->id} diubah menjadi completed");
            }
            
            // 2. Update ketersediaan kamar untuk booking yang sudah selesai
            $completedRoomBookings = Booking::whereIn('status', ['completed', 'cancelled'])
                ->with('rooms')
                ->get();
                
            foreach ($completedRoomBookings as $booking) {
                foreach ($booking->rooms as $bookingRoom) {
                    $room = Room::find($bookingRoom->room_id);
                    if ($room) {
                        $room->update(['is_available' => true]);
                        $this->info("Kamar #{$room->id} diubah menjadi tersedia");
                        Log::info("Kamar #{$room->id} diubah menjadi tersedia");
                    }
                }
            }
            
            // 3. Update property availability records
            PropertyAvailability::where('status', 'booked')
                ->whereHas('booking', function ($query) {
                    $query->where('check_out', '<', Carbon::now()->startOfDay());
                })
                ->update([
                    'status' => 'available',
                    'booking_id' => null
                ]);
                
            $this->info('Property availability records diperbarui');
            Log::info('Property availability records diperbarui');
            
            DB::commit();
            
            $this->info('Pembaruan status booking selesai');
            Log::info('Pembaruan status booking otomatis selesai');
            
            return 0;
        } catch (\Exception $e) {
            DB::rollBack();
            $this->error('Error: ' . $e->getMessage());
            Log::error('Error saat memperbarui status booking: ' . $e->getMessage());
            
            return 1;
        }
    }
}
