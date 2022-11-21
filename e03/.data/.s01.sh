#!/bin/bash
if [ $# -eq 0 ]
then
	echo "This script requires one or more filenames as parameters - exiting"
	exit
fi

total=0
min=-1
max=0
for file in ${@}
do
	if [ ! -e $file ]
	then
		echo "The file $file does not exist - exiting"
		exit
	fi
	size=$( cat $file | wc -c )
	if [  $min -eq -1 ]
	then
		min=$size
	elif [ $size -lt $min ]
	then
		min=$size
	fi
	if [ $size -gt $max ]
	then
		max=$size
	fi
	total=$((total+size))
done

echo "Count = $#"
echo "Total = $total"
echo "Min   = $min"
echo "Max   = $max"
