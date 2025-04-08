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
        Schema::create('subdistricts', function (Blueprint $table) {
            $table->id(); // Primary Key
            $table->string('subdis_name', 100); // Nama Kelurahan/Desa
            $table->foreignId('dis_id')->constrained('districts')->onDelete('cascade'); // Foreign Key ke districts
            $table->timestamps();
        });
    }

    public function down() {
        Schema::dropIfExists('subdistricts');
    }
};
