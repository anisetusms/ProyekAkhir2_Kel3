<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up()
    {
        Schema::create('room_facilities', function (Blueprint $table) {
            $table->id('id_room_facilities');
            $table->string('facility_name');
            $table->text('description')->nullable();
            $table->foreignId('id_room')->constrained('rooms')->cascadeOnDelete(); // Perbaiki 'room' menjadi 'rooms'
            $table->timestamps();
            $table->boolean('is_deleted')->default(false);
        });
    }

    public function down()
    {
        Schema::dropIfExists('room_facilities');
    }
};
