#!/bin/bash
word="${1:-NOTHING}"
if [ $word = "NOTHING" ]
then
  echo -en "Input word missing.\n"
  echo -en "Script will run with default value (NOTHING), then exit.\n"
fi

read -p "Enter the file you want to search: " file
if [ ! -f "$file" ]
then
  echo -en "$file does not exist.\n"
  echo -en "Script will use default value (test.txt), then exit.\n"
  file="test.txt"
fi

grep -iw $word $file
if [[ $word != "NOTHING" && $file != "test.txt" ]]
then 
  echo -en "$file has been searched for $word. The script will now exit."
else
  echo -rn "test.txt has been searched for NOTHING. The script will now exit."
fi
