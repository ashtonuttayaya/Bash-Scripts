#!/bin/bash
file="$1"
if [  ! -z "$file" ] 
then
	if [ -e "$file" ]
	then
		word="test"
		while [ ! -z "$word" ]
		do

			echo -n "Enter a word to search for (press return with no word to quit): "
			read word
			if [ ! -z "$word" ]
			then
				grep -iw $word $file | wc -l
			fi
		done
		echo ""
	else
		echo "Requested file, $file, not found"
	fi
else
	echo "Missing filename"
fi
