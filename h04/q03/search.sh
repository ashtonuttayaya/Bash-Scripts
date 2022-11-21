#!/bin/bash
word="$1"

echo -n "Enter the file you want to search: "
read file

grep -iw $word $file
