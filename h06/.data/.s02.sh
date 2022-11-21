#!/bin/bash
#
user="h6_fml_lcd"		# change to the mysql username you created
pass="h6_fml_lcd"		# change to the mysql password you created

mysql -u $user -p$pass < createdb.sql > q02.txt 2>/dev/null

