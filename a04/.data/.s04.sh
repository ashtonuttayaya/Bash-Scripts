#!/bin/bash
dir=$(pwd)
flag=`echo $dir|awk '{print match($0,"a04/q04")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a04/q04
fi

	n1=$( grep -i "INSERT" $qdir/agents.sql  | wc -l ) 
	n2=$( grep -i "INSERT" $qdir/dealers.sql | wc -l ) 
	n3=$( grep -i "INSERT" $qdir/owners.sql  | wc -l ) 
	n4=$( grep -i "'AL'" $qdir/dealers.sql | wc -l )
	n5=$( grep -i "'Walker'" $qdir/owners.sql | wc -l )
	d1=$( cat $qdir/SALESDATA/agents.txt       | wc -l ) 
	d2=$( grep -iv "Dealer Name" $qdir/SALESDATA/dealerships.txt   | wc -l ) 
	d3=$( grep -iv "Dealer Name" $qdir/SALESDATA/dealerships.txt   | wc -l ) 
	d4=$( grep -iw  "AL"     $qdir/SALESDATA/dealerships.txt 	 | wc -l )
	d5=$( grep -i "Walker" $qdir/SALESDATA/dealerships.txt | wc -l )


	echo "Agents	: DATA=$d1 SQL=$n1"
	echo "Dealers	: DATA=$d2 SQL=$n2"
	echo "Owners	: DATA=$d3 SQL=$n3"
	echo "Alabama	: DATA=$d4 SQL=$n4"
	echo "Walker	: DATA=$d5 SQL=$n5"
