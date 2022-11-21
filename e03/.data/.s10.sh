#!/bin/bash
if [ $# -eq 0 ]
then
	echo "No title provided - exiting"
	exit
fi
search="$1"
found=$(grep -i "$search" movies.dat | wc -l )
if [ $found -eq 0 ]
then
	echo "Requested movie title \"$search\" Not Ranked - exiting"
	exit
fi
if [ $found -gt 1 ]
then
	echo "Multiple listings for \"$search\" found $found times - exiting"
	exit
fi
string=$(cat movies.dat | grep -i "$search" )
IFS="," read -ra data <<< "$string"
echo -n "Title = ${data[0]}  Year = ${data[1]}  Rank = ${data[2]}"
echo    "  Men = ${data[3]}  Women = ${data[4]}  Total = ${data[5]}"
