<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up()
    {
        Schema::create('order_properties', function (Blueprint $table) {
            $table->id();
            $table->foreignId('property_id')->constrained('property')->cascadeOnDelete(); // Pastikan nama tabel benar
            $table->date('check_in');
            $table->date('check_out');
            $table->foreignId('order_id')->constrained('orders')->cascadeOnDelete(); // Pastikan orders sudah dibuat
            $table->timestamps();
            $table->boolean('is_deleted')->default(false);
        });
    }

    public function down()
    {
        Schema::dropIfExists('order_properties');
    }
};
