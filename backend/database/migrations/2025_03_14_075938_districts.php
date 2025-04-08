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
        Schema::create('districts', function (Blueprint $table) {
            $table->id(); // Primary Key
            $table->string('dis_name', 100); // Nama Kecamatan
            $table->foreignId('city_id')->constrained('cities')->onDelete('cascade'); // Foreign Key ke cities
            $table->timestamps();
        });
    }

    public function down() {
        Schema::dropIfExists('districts');
    }
};
