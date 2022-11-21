#!/bin/bash

dirName=$1

if [ ! -d "$1" ] || [ "$1" == "" ]; then
echo "Directory does not exist/Invalid directory"
exit 1
fi

dirFiles=$( ls $dirName/*.txt )
fileName="${dirName}.rpt"
echo "Directory = $dirName

Filename                  Chars     Words   Lines    Bytes     Wds/LN   b/Char
================================================================================" > $fileName

for file in $dirFiles; do
numChar=$( wc -m < $file )
numWord=$( wc -w < $file )
numLine=$( wc -l < $file )
numByte=$( wc -c < $file )
wordPLine=$( echo "scale=2; $numWord/$numLine" | bc )
bytePChar=$( echo "scale=2; $numByte/$numChar" | bc )

echo "$file             $numChar   $numWord   $numLine   $numByte   $wordPLine   $bytePChar" >> $fileName

done
echo "================================================================================" >> $fileName
