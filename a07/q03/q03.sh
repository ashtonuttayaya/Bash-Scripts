#!/bin/bash

carModel=$1

echo "USE sales;" > q03.sql

echo "SELECT DISTINCT(model_name) FROM sales_2010 WHERE model_name='$carModel';" >> q03.sql
output=$(mysql -N -u $MYSQLU -p$MYSQLP < q03.sql 2>/dev/null) 

if [ -z $output ]; then
   echo "Car Model Not Found"
   if [ -f report.tmp ]; then
      rm report.tmp
   fi
   exit 1
fi

if [ -f report.tmp ]; then
   rm report.tmp
fi

for type in "all" "new" "used"; do
   for year in {2010..2015}; do
   	salesdata=(  $( ../q02/q02.sh $year $carModel $type ) )
	printf "   %4s %9s %13s %13s %13s \n" ${salesdata[0]} ${salesdata[1]} ${salesdata[2]} ${salesdata[3]} ${salesdata[4]} >> report.tmp
   done
done





