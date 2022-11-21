#!/bin/bash
if [ $# -ne 1 ]
then
	echo "Year required as command line parameter"
	exit
fi
year=$1

if [ $year -lt 2010 ] || [ $year -gt 2015 ]
then
	echo "Year outside available range (2010 to 2015), quitting"
	exit
fi

cat > q03.sql << SQL
use sales;
select count(*) as NT from sales_$year;
select count(*) as NN from sales_$year where sales_type="new";
select count(*) as NU from sales_$year where sales_type="used";
SQL

mysql -u salesadmin -pLarry12! < q03.sql
