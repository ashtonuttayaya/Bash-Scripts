#!/bin/bash


source ~/class/h07/q02/q02.env

echo "USE sales;" > q03.sql

for i in {1..34}
do
echo "SELECT fname, lname, owner_id FROM owners WHERE owner_id=$i;" >> q03.sql
echo "SELECT COUNT(*), owner_id FROM dealers WHERE owner_id=$i;" >> q03.sql 
echo "SELECT fname, lname, owner_id FROM agents WHERE owner_id=$i;" >> q03.sql
done
num_owners=$( mysql -N -u $MYSQL_ADMIN -p$MYSQL_PAD < 'q03.sql' 2>/dev/null )

