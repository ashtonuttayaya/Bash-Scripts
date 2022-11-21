#!/bin/bash
word="$1"
echo -n "Enter the name of the file you want to search: "
read file
if [  ! -z "$file" ] 
then
	if [ -e "$file" ] && [ ! -z "$word" ]
	then
		echo "Searching for $word in $file"
		grep -iw $word $file
	else
		echo "File or word input error - exiting"
		exit
	fi
else
	echo "File or word input error - exiting"
	exit
fi
