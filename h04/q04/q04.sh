#!/bin/bash

file_input=$1

while [ true ]
do
    echo "Enter search term to find occurrence in file ${file_input}:"
    read searchterm
    if [ "${searchterm}" == "" ]
    then
        break
    else
        grep -iw ${searchterm} ${file_input} | wc -l
    fi
done

echo ""

