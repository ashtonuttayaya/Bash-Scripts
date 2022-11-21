#!/bin/bash

carModel=$1

echo "USE sales;" > q05.sql

echo "SELECT DISTINCT(model_name) FROM sales_2010;" >> q05.sql
mysql -N -u $MYSQLU -p$MYSQLP < q05.sql 2>/dev/null 1>car_models.txt

filename=car_models.txt
declare -a myArray
myArray=(`cat "$filename"`)

if [ -f report.tmp ]; then
   rm report.tmp
fi

for carModel in ${myArray[@]}; do
    ( 
        cd ../q04
        ./q04.sh $carModel
        if [ -e report.tmp ]
        then
                cp report.tmp "$REPORTS/$carModel"".txt"
                rm report.tmp
        fi
    )
done

(
	cd ~/reports
	reports=( $(ls *.txt) )
	tar -cf models.tar ${reports[@]}
	mv models.tar ~/archive
    )




