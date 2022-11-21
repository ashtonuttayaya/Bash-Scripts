#!/bin/bash
if [ $# -lt 2 ]
then
	echo "Script requires two paramaters:"
	echo "       database name"
	echo "       year"
	exit
fi
dbase="$1"
year="$2"
#
#	Setting output file name from database name and year
#	update_dev2008.sql
#
fn="update_"
fn="$fn""$dbase""$year"
fn="$fn"".sql"
#
#	Use Here doc structure to create the file
#
echo Creating the sql file needed to update the database
echo	The sql file name is: $fn
cat > $fn << SQLFILE
create database if not exists $dbase;
use $dbase;
source ./mysql/agents.sql
source ./mysql/dealers.sql
source ./mysql/owners.sql
source ./mysql/sales_$year.sql
SQLFILE
echo 
echo To complete the installation run mysql from this directory using the following command:
echo
echo "     mysql -u MYSQL_USER -pMYSQL_PASS < $fn &"
echo 
echo The above command will take 3-6 minutes to complete
echo Replace MYSQL_USER and MYSQL_PASS with the appropriate values
