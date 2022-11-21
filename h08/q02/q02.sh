#!/bin/bash

numArray=( "$@" )
count=0

if [[ $@ == "" ]]; then
exit 1
fi

#gets count
echo "Count = ${#numArray[@]}"

sum=0
#gets sum
for i in ${numArray[@]}; do
let sum+=$i
done
echo "Sum = $sum"

max=${numArray[0]}
min=${numArray[0]}

for i in ${numArray[@]}; do
(( i > max )) && max=$i
(( i < min )) && min=$i
done

echo "Min = $min"
echo "Max = $max"

