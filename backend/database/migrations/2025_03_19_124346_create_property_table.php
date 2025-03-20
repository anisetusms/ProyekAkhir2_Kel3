<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up()
    {
        Schema::create('property', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_owner')->constrained('owners')->cascadeOnDelete();
            $table->string('property_name');
            $table->text('description')->nullable();
            $table->foreignId('id_property_type')->nullable()->constrained('property_type')->nullOnDelete();
            $table->unsignedBigInteger('id_property_price')->nullable();
            $table->foreign('id_property_price')->references('id')->on('property_price')->onDelete('SET NULL');
            $table->timestamps();
            $table->boolean('is_deleted')->default(false);
        });
    }

    public function down()
    {
        Schema::dropIfExists('property');
    }
};
