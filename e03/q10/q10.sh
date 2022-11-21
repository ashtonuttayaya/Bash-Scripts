#!/bin/bash

title=$1

if [[ $title == "" ]]; then
   echo "No title entered"
   exit 1
fi

linematch=$( grep -i "$title" movies.dat | wc -l )

if [[ $linematch -gt 1 ]]; then
   echo "Multiple listing - please provide complete name"
   exit 1
fi

if [[ $linematch -eq 0 ]]; then
   echo "Not Ranked"
   exit 1
fi


string=$( cat movies.dat | grep -i "$title" )
IFS=',' read -ra data <<< "$string"
echo ${data[@]}
