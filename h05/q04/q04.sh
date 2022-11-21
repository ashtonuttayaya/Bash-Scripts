#!/bin/bash
filedata=insert_data.txt
infile=$1

if [ ! -e "$infile" ]; then
     echo "Please give an input file"
     exit
fi


while read fname lname ; do
	fname=${fname^^}
	lname=${lname^^}
	
	echo "STUDENT=$fname $lname"

	echo "HOMEWORK SCORES"
	echo "----------------------"
	grep "TYPE=HW" $filedata | grep $fname | grep $lname

	echo

	echo "QUIZ SCORES"
	echo "-----------------------"
	grep "TYPE=QU" $filedata | grep $fname | grep $lname

	echo

	echo "EXAM SCORES"
	echo "-----------------------"
	grep "TYPE=EX" $filedata | grep $fname | grep $lname

	echo ""	

done < $infile
