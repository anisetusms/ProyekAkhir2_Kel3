<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up()
    {
        Schema::create('rooms', function (Blueprint $table) {
            $table->id(); // unsignedBigInteger secara default
            $table->string('room_number');
            $table->text('description')->nullable();
            $table->foreignId('id_property')->constrained('property')->cascadeOnDelete();
            $table->timestamps();
            $table->boolean('is_deleted')->default(false);
        });
    }

    public function down()
    {
        Schema::dropIfExists('rooms');
    }
};
