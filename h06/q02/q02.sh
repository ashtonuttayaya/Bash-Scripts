#!/bin/bash
#
user="h6_aru"		# change to the mysql username you created
pass="Woodman123321"		# change to the mysql password you created

mysql -u $user -p$pass < createdb.sql > q02.txt 2>/dev/null

