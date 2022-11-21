#!/bin/bash
file="junkfile.txt"
if [ $# -gt 0 ]
then
file="$1"
fi
if [ $# -lt 1 ] || [ ! -e "$file"  ]
then
        echo "Error: script requires one valid filename"
        exit
fi
bytes=($(ls -lar "$file"))
lines=($(wc "$file"))
wpl=$(echo "scale=2; ${lines[1]}/${lines[0]}" | bc )
bpc=$(echo "scale=2; ${bytes[4]}/${lines[2]}" | bc )
declare -a output
output=( "${lines[3]}" "${lines[2]}" "${lines[1]}" "${lines[0]}" "${bytes[4]}" "$wpl" "$bpc" )
echo "${output[@]}"

