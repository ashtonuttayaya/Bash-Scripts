#!/bin/bash

flag=$1
number=$2

if [ $flag != 'H' ] && [ $flag != 'Q' ] && [ $flag != 'E' ]; then
  echo "Please enter H, Q, or E"
  exit 1
fi

if [ $flag = 'H' ]; then
  type="Homework"
  type2="HW"
elif [ $flag = 'Q' ]; then
  type="Quiz"
  type2="QU"
elif [ $flag = 'E' ]; then
  type="Exam"
  type2="EX"
fi



text_count=$(grep -E "SCORE=$number$" insert_data.txt | grep "TYPE=$type2" | wc -l)
echo "(TXT) $type score = $number count = $text_count" 

sql_count=$(grep -E "'$number'\)" insert_data.sql | grep "'$type2'," | wc -l)
echo "(SQL) $type score = $number count = $sql_count"
