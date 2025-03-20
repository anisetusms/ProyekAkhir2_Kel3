<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up()
    {
        Schema::create('property_images', function (Blueprint $table) {
            $table->id('id_property_images');
            $table->text('images');
            $table->foreignId('id_property')->constrained('property')->cascadeOnDelete();
            $table->timestamps();
            $table->boolean('is_deleted')->default(false);
        });
    }

    public function down()
    {
        Schema::dropIfExists('property_images');
    }
};
