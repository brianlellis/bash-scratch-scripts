#!/bin/bash

clear
echo "====================="
echo "=== Create Module ==="
echo "====================="

cat -n << EOF
Vendor Name?
  Options
  [1] Core
  [2] Suretypedia
  [3] BondExchange
  [4] Jet Surety
  [5] CCIS
EOF
read VENDOR_NAME

if [ $VENDOR_NAME == "1" ] ;then
  VENDOR_NAME="core"
elif [ $VENDOR_NAME == "2" ] ;then
  VENDOR_NAME="suretypedia"
elif [ $VENDOR_NAME == "3" ] ;then
  VENDOR_NAME="bondexchange"
elif [ $VENDOR_NAME == "4" ] ;then
  VENDOR_NAME="jetsurety"
elif [ $VENDOR_NAME == "5" ] ;then
  VENDOR_NAME="ccis"
fi

echo -n "What is the module name? "
read MODULE_NAME
MODULE_NAME=$( echo $MODULE_NAME | tr '[:upper:]' '[:lower:]')
echo "module_${VENDOR_NAME}_${MODULE_NAME}"

cd ../app/Frostbite

# CAPTALIZE MODULE VENDOR NAME
first=`echo $VENDOR_NAME|cut -c1|tr [a-z] [A-Z]`
second=`echo $VENDOR_NAME|cut -c2-`
VENDOR_NAME=$first$second

mkdir -p $VENDOR_NAME && cd $VENDOR_NAME

# NAME MODULE CORRECTLY
first=`echo $MODULE_NAME|cut -c1|tr [a-z] [A-Z]`
second=`echo $MODULE_NAME|cut -c2-`
MODULE_NAME=$first$second

mkdir $MODULE_NAME && cd $MODULE_NAME
mkdir Data Controllers Helpers Models
echo "<?php" > web.php

# DATA FILE CREATORS
cd Data
cat > _____${MODULE_NAME}DataCreator.php <<EOF
<?php
use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ${MODULE_NAME}DataCreator extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        // Schema::create('test', function (Blueprint $table) {
        //     $table->increments('id');
        //     $table->timestamps();
        //     $table->softDeletes();
        //     $table->string('name', 250);
        // });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {

    }
}
EOF

cat > ${MODULE_NAME}DataSeeder.php << EOF
<?php

namespace App\Frostbite\\${VENDOR_NAME}\\${MODULE_NAME}\Data;

use Illuminate\Database\Seeder;

class ${MODULE_NAME}DataSeeder extends Seeder
{

    /**
     * Auto generated seed file
     *
     * @return void
     */
    public function run()
    {
        // $date_now = date('Y-m-d H:i:s');

        // \DB::table('test')->delete();
        // \DB::table('test')->insert(array(
        //     0 =>
        //     array(
        //         'created_at' => $date_now,
        //         'updated_at' => $date_now,
        //     ),
        // ));
    }
}
EOF

cd ../Controllers

cat > Example.php << EOF
<?php

namespace App\Frostbite\\${VENDOR_NAME}\\${MODULE_NAME}\Controllers;

use App\User;
use App\Http\Controllers\Controller;

class Example extends Controller
{
    public function index()
    {
        return 'Hello';
    }
}
EOF
