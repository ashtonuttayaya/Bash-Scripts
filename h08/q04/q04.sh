#!/bin/bash
numArray=( "$@" )
Count=${#numArray[@]}

if [[ $@ == "" ]]; then
   exit 1
fi

echo "Count = ${#numArray[@]}"

Sum=$( IFS="+"; bc <<< "${numArray[*]}" )

echo "Sum = $Sum"

Ave=$( echo "scale=2; $Sum/$Count;" | bc )

echo "Ave = $Ave"
