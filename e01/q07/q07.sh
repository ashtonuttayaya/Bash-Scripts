#!/bin/bash

file1=$1
file2=$2

echo "The character lengths are requested for $file1 and $file2"
wc -c $file1
wc -c $file2
