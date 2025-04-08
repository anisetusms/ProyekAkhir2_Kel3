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
        Schema::create('provinces', function (Blueprint $table) {
            $table->id(); // Primary Key
            $table->string('prov_name', 100); // Nama Provinsi
            $table->integer('locationid')->nullable(); // Opsional (jika dibutuhkan)
            $table->boolean('status')->default(1); // Aktif atau tidak
            $table->timestamps();
        });
    }

    public function down() {
        Schema::dropIfExists('provinces');
    }
};
