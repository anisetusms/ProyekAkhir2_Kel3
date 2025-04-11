<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('cities', function (Blueprint $table) {
            $table->id(); // id BIGINT(20) UNSIGNED NOT NULL
            $table->string('name', 100); // city_name VARCHAR(100)
            $table->unsignedBigInteger('province_id'); // prov_id BIGINT(20) UNSIGNED NOT NULL

            $table->foreign('prov_id')->references('id')->on('provinces')->onDelete('cascade');
            
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cities');
    }
};
