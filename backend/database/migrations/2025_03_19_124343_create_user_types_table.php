<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up()
    {
        Schema::create('user_types', function (Blueprint $table) {
            $table->id(); // otomatis bigInt unsigned
            $table->string('name');
            $table->text('DESCRIPTION')->nullable();
            $table->timestamps();
            $table->boolean('is_deleted')->default(false);
        });
    }

    public function down()
    {
        Schema::dropIfExists('user_types');
    }
};

