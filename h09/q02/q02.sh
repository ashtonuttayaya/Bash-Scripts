#!/bin/bash
inputFile=$1

if [ ! -f "$1" ] || [ "$1" == "" ]; then
echo "File does not exist/File was not inputted"
exit 1
fi

numChar=$( wc -m < $inputFile )
numWord=$( wc -w < $inputFile )
numLine=$( wc -l < $inputFile )
numByte=$( wc -c < $inputFile )

echo "$inputFile"
echo "$numChar"
echo "$numWord"
echo "$numLine"
echo "$numByte"
echo "scale=2; $numWord/$numLine" | bc
echo "scale=2; $numByte/$numChar" | bc
