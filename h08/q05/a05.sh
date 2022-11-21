#!/bin/bash
if [ $# -lt 1 ]
then
        echo "Script requires filename as parameter - can't continue"
        exit
fi

file=$1
if [ ! -e $file ]
then
        echo "Requested $file not found - can't continue"
        exit
fi 

printf '%-30s   %3s   %5s   %6s\n' "Name" " # " "Total" " Ave. "
printf '%-30s   %3s   %5s   %6s\n' "==============================" "===" "=====" "======"

while read line
do
        array=()
        array=( $line )
        echo "${line[@]}"
done < $file

printf '%-30s   %3s   %5s   %6s\n' "==============================" "===" "=====" "======"

