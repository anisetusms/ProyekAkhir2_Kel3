<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up()
    {
        Schema::create('customer', function (Blueprint $table) {
            $table->id();
            $table->string('username');
            $table->string('identity_number', 50)->unique();
            $table->string('phone_number', 20)->nullable();
            $table->string('email')->unique();
            $table->text('address')->nullable();
            $table->string('subdis_id', 50)->nullable();
            $table->string('whatsapp_number', 20)->nullable();
            $table->text('photo_file')->nullable();
            $table->timestamps();
            $table->boolean('is_deleted')->default(false);
        });
    }

    public function down()
    {
        Schema::dropIfExists('customer');
    }
};
