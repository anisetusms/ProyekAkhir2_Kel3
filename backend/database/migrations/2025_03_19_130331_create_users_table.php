<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id('user_id');
            $table->string('username');
            $table->string('personal_id', 50)->unique()->nullable();
            $table->foreignId('userType_id')->nullable()->constrained('user_types')->nullOnDelete();
            $table->text('token')->nullable();
            $table->string('password');
            $table->string('email')->unique();
            $table->foreignId('role_id')->nullable()->constrained('user_roles')->nullOnDelete();
            $table->timestamps();
            $table->boolean('is_deleted')->default(false);
        });
    }

    public function down()
    {
        Schema::dropIfExists('users');
    }
};
