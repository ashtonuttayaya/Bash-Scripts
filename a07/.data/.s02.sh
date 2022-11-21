#!/bin/bash
##################################################################################################
#
#	SCRIPT:		script02.sh
#	AUTHOR:		L. Dennis (Larry.Dennis@cci.fsu.edu)
#	DATE:		Nov. 1, 2015
#	VERSION:	1.0
#
#	PURPOSE:	This script returns sales information for a specific year from sales 
#			database.  Script requires the year, model name and sales type (all, new, used)
#			as parameters.  It returns the following:
#				year
#				number of cars sold
#				total dealer cost of the cars
#				total amount paid for cars
#				total list prices of the cars
#
####################################################################################################
if [ ! -e env_mysql ]
then
	ln -s ../q01/env_mysql env_mysql
fi

source env_mysql

if [ $# -ne 3 ]
then
	echo "This script requires 3 parameters, a year, a model name and one of new, used, or all"
	exit
fi
year=$1
model=$2
type=$3
#
#	Create the required sql statement according to the required type
#
if [ "$type" == "all" ]
then
cat > q02.sql << SQL
use sales;
select count(*), sum(dealer_cost), sum(price_sold), sum(price_list) from sales_$year where model_name='$model';
SQL

elif [ "$type" == "new" ]
then
cat > q02.sql << SQL
use sales;
select count(*), sum(dealer_cost), sum(price_sold), sum(price_list) from sales_$year where model_name='$model' and sales_type='new';
SQL

elif [ "$type" == "used" ]
then
cat > q02.sql << SQL
use sales;
select count(*), sum(dealer_cost), sum(price_sold), sum(price_list) from sales_$year where model_name='$model' and sales_type='used';
SQL

else
	echo " Wrong type specified"
	exit
fi
#
#	Run the statement and get the values we need, store them in an array
#
salesdata=( $(mysql -u $MYSQLU -p$MYSQLP < q02.sql | grep -v count) ) 
for i in {0..3}
do
	if [ "${salesdata[$i]}" == "NULL" ]
	then
		salesdata[$i]=0
	fi
done
#
#	Output the results as year, # sold, total dealer cost, total amount received, total list price 
#
echo "$year ${salesdata[@]}"
#
#	Remove the temporary file
#
rm q02.sql

