#!/bin/bash
file="$1"
if [ -z "$file" ]
then
	echo "No input file name provided. Exiting"
	exit
fi
if [ ! -e $file ]
then
	echo "Requested input file not found. Exiting"
	exit
fi

while read fname lname
do
	if [ ! -z "$fname" ] && [ ! -z "$lname" ]
	then
		echo "Scores for $fname $lname"
		echo "Homework ========"
		grep -i "FNAME=$fname" insert_data.txt | grep -i "LNAME=$lname" | grep -i "TYPE=HW"
		echo "Quizzes ========="
		grep -i "FNAME=$fname" insert_data.txt | grep -i "LNAME=$lname" | grep -i "TYPE=QU"
		echo "Exams ==========="
		grep -i "FNAME=$fname" insert_data.txt | grep -i "LNAME=$lname" | grep -i "TYPE=EX"
		echo ""
	fi
done < $file
