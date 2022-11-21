#!/bin/bash
cp movies.xml cmovies.txt
sed -i 's/<MOVIES>//g' cmovies.txt
sed -i 's/<\/MOVIES>//g' cmovies.txt
sed -i 's/<MOVIE>//g' cmovies.txt
sed -i 's/<\/MOVIE>//g' cmovies.txt
sed -i 's/<TITLE>//g' cmovies.txt
sed -i 's/<RANK>//g' cmovies.txt
sed -i 's/<YEAR>//g' cmovies.txt
sed -i 's/<MEN>//g' cmovies.txt
sed -i 's/<WOMEN>//g' cmovies.txt
sed -i 's/<TOTAL>//g' cmovies.txt
sed -i 's/<\/TITLE>/,/g' cmovies.txt
sed -i 's/<\/RANK>/,/g' cmovies.txt
sed -i 's/<\/YEAR>/,/g' cmovies.txt
sed -i 's/<\/MEN>/,/g' cmovies.txt
sed -i 's/<\/WOMEN>/,/g' cmovies.txt
sed -i 's/<\/TOTAL>/,/g' cmovies.txt
sed -i '/^\s*$/d' cmovies.txt
