#!/bin/bash

if [ $# -lt 1 ]
then
        echo "Script requires directory name"
        exit
fi
dir=$1
if [ ! -e $dir ]
then
        echo "$dir does not exist"
        exit
fi

dir=$1
(
        cd $dir
echo "$dir"
        for file in *.txt
        do
#	wc $file
                array=( $(wc $file) )
                echo "${array[3]} ${array[0]} ${array[1]}"
        done
)

