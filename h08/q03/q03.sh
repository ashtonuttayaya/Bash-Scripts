#!/bin/bash

directory=$1

dir=~/class/h08/q03/$directory
echo "$dir"
cd $dir

txts=( $( ls *.txt ) )
for txt in ${txts[@]}; do
   lines=$( cat $txt | wc -l )
   words=$( cat $txt | wc -w )
   echo $txt $lines $words
done



