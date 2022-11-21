#!/bin/bash
sed 's/<MOVIES>//g' < movies.xml > cmovies.txt

for string in "<MOVIE>" "<TITLE>" "<RANK>" "<YEAR>" "<MEN>" "<WOMEN>" "<TOTAL>" "<\/MOVIES>"
do
        sed -i "s/$string//g" cmovies.txt
done

for string in "<\/MOVIE>" "<\/TITLE>" "<\/RANK>" "<\/YEAR>" "<\/MEN>" "<\/WOMEN>" "<\/TOTAL>" 
do
        sed -i "s/$string/,/g" cmovies.txt
done

sed -i 's/, ,//g' cmovies.txt
sed -i 's/  / /g' cmovies.txt
sed -i 's/^ //g' cmovies.txt
sed -i '/^\s*$/d' cmovies.txt
