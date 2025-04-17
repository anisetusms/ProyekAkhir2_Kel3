<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up()
    {
        // 1. Ubah tipe data property_type_id agar konsisten
        DB::statement('ALTER TABLE properties MODIFY property_type_id BIGINT UNSIGNED NOT NULL');

        // 2. Set kolom required tidak boleh NULL
        Schema::table('properties', function (Blueprint $table) {
            $table->text('address')->nullable(false)->change();
            $table->decimal('latitude', 10, 8)->nullable(false)->change();
            $table->decimal('longitude', 11, 8)->nullable(false)->change();
            
            // 3. Tambahkan foreign key constraint
            $table->foreign('property_type_id')
                  ->references('id')
                  ->on('property_types')
                  ->onDelete('restrict');
        });

        // 4. Update struktur property_types jika perlu
        Schema::table('property_types', function (Blueprint $table) {
            $table->renameColumn('property_type', 'name');
        });
    }

    public function down()
    {
        // Rollback changes
        Schema::table('properties', function (Blueprint $table) {
            $table->dropForeign(['property_type_id']);
            $table->integer('property_type_id')->nullable()->change();
            $table->text('address')->nullable()->change();
            $table->decimal('latitude', 10, 8)->nullable()->change();
            $table->decimal('longitude', 11, 8)->nullable()->change();
        });

        Schema::table('property_types', function (Blueprint $table) {
            $table->renameColumn('name', 'property_type');
        });
    }
};