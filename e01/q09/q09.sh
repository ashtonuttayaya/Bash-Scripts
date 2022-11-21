#!/bin/bash

file1=$1
file2=$2
file3=$3

cp /dev/null headers.txt

if [[ -f $file1 ]]
then 
	echo "Does exist"
	head -3 $file1 >> headers.txt
else
	echo "Does not exist"
fi

if [[ -f $file2 ]]
then 
	echo "Does exist"
	head -3 $file2 >> headers.txt
else
	echo "Does not exist"
fi

if [[ -f $file3 ]]
then
	echo "Does exist"
	head -3 $file3 >>headers.txt
else
	echo "Does not exist"
fi

