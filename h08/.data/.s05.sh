#!/bin/bash
if [ $# -lt 1 ]
then
echo "Script requires filename as parameter -can't continue"
exit
fi

file=$1
if [ ! -e $file ]
then
echo "$file not found - can't continue"
exit
fi 

printf '%-30s   %3s   %5s   %6s\n' "Name" " # " "Total" " Ave. "
printf '%-30s   %3s   %5s   %6s\n' "==============================" "===" "=====" "======"
while read line
do
array=()
array=( $line )
name="${array[1]}, ${array[0]}"
#
#	Determine the array size
#
num=${#array[@]}
n1=$((num-1))
#
#	Begin loop over values entered
#
i=2
total=0
count=$((num-i))
#
#	Calculate the total and the average value
#
while [ $i -le $n1 ]
do
sc=${array[$i]}
total=$((total+sc))
i=$((i+1))

done
avg=$( echo " scale=2; $total/$count" | bc )
printf '%-30s   %3s   %5s   %6s\n' "$name" $count $total $avg
done < $file
printf '%-30s   %3s   %5s   %6s\n' "==============================" "===" "=====" "======"
