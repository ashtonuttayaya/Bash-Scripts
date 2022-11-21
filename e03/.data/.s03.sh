#!/bin/bash
if [ $# -eq 0 ]
then
	echo "No file name provided - exiting"
	exit
fi
file=$1
if [ ! -e $file ]
then
	echo "$file not found - exiting"
	exit
fi

diff $file standard.txt > output
ndiffs=$( cat output | grep "^<" | wc -l )
nlines=$( cat $file | wc -l )
percent=$( echo "scale=2; 100.0*$ndiffs/$nlines" | bc ) 
echo "Name = $file   # diffs = $ndiffs   # lines = $nlines   % diffs = $percent"
rm output
