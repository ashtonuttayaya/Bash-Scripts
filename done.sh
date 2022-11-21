#!/bin/bash
fname=$1
lname=$2
assignment=$3
if [ "$#" -ne 3 ]
then
	echo "${BASH_SOURCE[0]}	- requires 3 parameters"
	echo "			- your first name"
	echo "			= your last name"
	echo "			- the name of the assignment"
else 
	dir=$(pwd)
	program=$dir/done/done.pl
	echo "Calling $program $fname $lname $assignment"
	$program $fname $lname $assignment
	( cd $dir/$assignment

	  	file=$(ls -1 *.txt)
		if [ ! -z "$file" ]
		then
		  	if [ -e $file ]
		  	then
				newfile=${file/txt/dat} 
				cp $file $newfile
				echo ""
				echo "Copy of $file put in $newfile"
			fi
		fi
	)
fi
