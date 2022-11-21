#!/bin/bash

input_param=$1

echo "USE DATABASE h6db_aru" > q05.sql

echo "SELECT COUNT(*) FROM students;" >> q05.sql

if [ "$input_param" == "Y" ]; then
  echo "SELECT COUNT(*) FROM students WHERE year=1;" >> q05.sql
  echo "SELECT COUNT(*) FROM students WHERE year=2;" >> q05.sql
  echo "SELECT COUNT(*) FROM students WHERE year=3;" >> q05.sql
  echo "SELECT COUNT(*) FROM students WHERE year=4;" >> q05.sql
  echo "SELECT COUNT(*) FROM students WHERE year=5;" >> q05.sql
  echo "SELECT COUNT(*) FROM students WHERE year=6;" >> q05.sql
elif [ "$input_param" ==  "G" ]; then
  echo "SELECT COUNT(*) FROM students WHERE gender=1;" >> q05.sql
  echo "SELECT COUNT(*) FROM students WHERE gender=2;" >> q05.sql
else 
  echo "Valid command not entered"
  rm q05.sql
  exit
fi
