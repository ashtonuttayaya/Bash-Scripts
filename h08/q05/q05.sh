#!/bin/bash
file=$1

printf '%-30s   %3s   %5s   %6s\n' "Name" " # " "Total" " Ave. "
printf '%-30s   %3s   %5s   %6s\n' "==============================" "===" "=====" "======"

while IFS=$' ' read -r -a line
do
        array=()
        array=( $line )
	totalNum=$( echo "scale=2; ${#line[@]} - 2;" | bc )
	total=0
	for i in {2..12}; do
		number=${line[${i}]}	
		let total+=number
	done
	Avg=$( echo "scale=2; $total/$totalNum;" | bc ) 
	printf '%-30s   %3s   %5s   %6s\n' "${line[1]}, ${line[0]}" "$totalNum" "$total" "$Avg"
done < $file

printf '%-30s   %3s   %5s   %6s\n' "==============================" "===" "=====" "======"


