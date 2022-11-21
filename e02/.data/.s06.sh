#!/bin/bash
echo ""
for file in $(ls reports/*.rpt)
do
	nwords=$(cat $file | wc -w)
	if [ $nwords -lt 700 ]
	then
		result="TOO SHORT"
	elif [ $nwords -gt 800 ]
	then
		result="TOO LONG"
	else
		result="OK"
	fi
	nthe=$(grep -iwo the $file | wc -l)
	nsthe=$(grep -iwE "^the" $file | wc -l)
	nwe=$(grep -iwE "^we|we$" $file | wc -l)
	echo "$file  $nwords:  $result"
	echo "       Number of times \"the\" occurs = $nthe" 
	echo "       Number of times \"the\" occurs at the start of a line = $nsthe"
	echo "       Number of times \"we\" occurs at the start or end of a line = $nwe"
	echo "" 
done

