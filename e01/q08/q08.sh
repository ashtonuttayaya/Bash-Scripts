#!/bin/bash

echo "Choose file: "

read file
if [[ -f $file ]]
then
	echo "File exists"
	grep -iw good $file
fi

if [[ ! -f $file ]]
then
	echo "File does not exist"
	exit
fi


