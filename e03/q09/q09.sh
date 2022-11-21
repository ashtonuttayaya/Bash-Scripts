#!/bin/bash

echo "USE budget;"
echo "CREATE IF NOT EXISTS TABLE expenses( name_id INT, fname VARCHAR(25),"
echo " lname VARCHAR(25), item VARCHAR(25), cost DECIMAL(8,2) NOT NULL,"
echo " edate DATE, primary key(expense_id) );"
while read line; do
   echo "INSERT INTO expenses ( name_id, fname, lname, item, cost, edate )"
   read -a textArray <<< "$line"
   lname=$( echo ${textArray[0]} | sed -e 's/LNAME=//' )
   fname=$( echo ${textArray[1]} | sed -e 's/FNAME=//' ) 
   nameID=$( echo ${textArray[2]} | sed -e 's/ID=//' )
   item=$( echo ${textArray[3]} | sed -e 's/ITEM=//' )
   cost=$( echo ${textArray[4]} | sed -e 's/COST=//' )
   edate=$( echo ${textArray[5]} | sed -e 's/DATE=//' )
   echo "VALUES( '$nameID', '$fname', '$lname', '$item', '$cost', '$edate' );"
done < dec.txt

