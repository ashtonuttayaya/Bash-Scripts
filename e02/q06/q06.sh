#!/bin/bash

cd reports

for report in `ls *.rpt`; do
    wordLength=$( wc -w < $report )
    wordLengthName="" 
    if [[ $wordLength -lt 700 ]]; then
	wordLengthName="TOO SHORT"
    elif [[ $wordLength -gt 800 ]]; then
	wordLengthName="TOO LONG"
    else
	wordLengthName="OK"
    fi
   echo $report	word length:  $wordLengthName
   theCount=$( grep -i -o -r "\bthe\b" $report | wc -l )
   echo "Number of times the word the occurs = $theCount"
   theStart=$( grep -i -E "^the\b" $report | wc -l )
   echo "Number of times the word the occurs at the start of the line = $theStart"
   weLine=$( grep -i -E "^we\b|\bwe$" $report | wc -l )
   echo "Number of times the word we occurs at the start or end of a line = $weLine" 
done
