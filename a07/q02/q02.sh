#!/bin/bash

yearSold=$1
carModel=$2
carType=$3

echo "USE sales;" > q02.sql

if [ $carType == "all" ]; then
   echo "SELECT COUNT(*), SUM(dealer_cost), SUM(price_sold), SUM(price_list) FROM sales_$yearSold WHERE model_name='$carModel';" >> q02.sql 
else
   echo "SELECT COUNT(*), SUM(dealer_cost), SUM(price_sold), SUM(price_list) FROM sales_$yearSold WHERE model_name='$carModel' AND sales_type='$carType';" >> q02.sql
fi

read -a output <<< $(mysql -N -u $MYSQLU -p$MYSQLP < q02.sql 2>/dev/null) 

echo "$yearSold ${output[0]} ${output[1]} ${output[2]} ${output[3]}"

