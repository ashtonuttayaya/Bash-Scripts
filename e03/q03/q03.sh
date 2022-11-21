#!/bin/bash

fileName=$1

if [[ $fileName == "" ]] || [[ ! -f $fileName ]]; then
   echo "File does not exist/Field empty"
   exit 1
fi


numLines=$( wc -l < $fileName )
numDifferences=$( diff $fileName standard.txt | grep "<" | wc -l )
percentDiff=$( echo "scale=2; 100 * $numDifferences/$numLines" | bc )

echo $fileName $numDifferences $numLines $percentDiff
