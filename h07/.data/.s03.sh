#!/bin/bash
echo "use sales;"
for i in {1..34}
do
	echo "select fname, lname, owner_id from owners where owner_id='$i';"
	echo "select count(*), owner_id from dealers where owner_id='$i';"
	echo "select fname, lname, owner_id from agents where owner_id='$i';"
done
