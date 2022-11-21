#!/bin/bash

# put the initial header in the sql file

echo "USE budget;"
echo "CREATE IF NOT EXISTS TABLE expenses( name_id INT, fname VARCHAR(25),"
echo "lname VARCHAR(25), item VARCHAR(25), cost DECIMAL(8,2) NOT NULL,"
echo "edate DATE, primary key(expense_id) );"

# Read the file and process each line, then output the sql statements

declare -a line

while read -a line
do
	echo "INSERT INTO expenses ( name_id, fname, lname, item, cost, edate )"
	lname=${line[0]}
	fname=${line[1]}
	name_id=${line[2]}
	item=${line[3]}
	cost=${line[4]}
	date=${line[5]}
	lname=${lname/LNAME=/}
	fname=${fname/FNAME=/}
	name_id=${name_id/ID=/}
	item=${item/ITEM=/}
	cost=${cost/COST=/}
	date=${date/DATE=/}

	echo "VALUES( '$name_id', '$fname', '$lname', '$item', '$cost', '$date' );" 
done < dec.txt
