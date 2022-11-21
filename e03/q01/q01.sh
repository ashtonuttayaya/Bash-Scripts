#!/bin/bash

fileArray=( "$@" )

if [[ $@ == "" ]]; then
   echo "Field empty"
   exit 1
fi

for file in "${fileArray[@]}"; do
   if [[ ! -f $file ]]; then
     echo "File does not exist"
     exit 1
   fi
done

min=0
max=0

for files in "${fileArray[@]}"; do
  wordCount=$(wc -m < $files)
   if [[ $wordCount -gt $max ]]; then
      max=$wordCount
   fi
   if [[ $min -eq 0 ]] || [[ $wordCount -lt $min ]]; then
      min=$wordCount
   fi 
   let sum+=$wordCount
done

echo "Count =  ${#fileArray[@]}"
echo "Total = $sum"
echo "Min = $min"
echo "Max = $max"
