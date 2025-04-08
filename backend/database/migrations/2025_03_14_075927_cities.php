<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up() {
        Schema::create('cities', function (Blueprint $table) {
            $table->id(); // Primary Key
            $table->string('city_name', 100); // Nama Kota/Kabupaten
            $table->foreignId('prov_id')->constrained('provinces')->onDelete('cascade'); // Foreign Key ke provinces
            $table->timestamps();
        });
    }

    public function down() {
        Schema::dropIfExists('cities');
    }
};
