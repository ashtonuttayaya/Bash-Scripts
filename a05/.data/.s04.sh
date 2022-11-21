#!/bin/bash
vin="JE142FU154525XBX8"
dir=$(pwd)
for year in {2010..2015}
do
	echo "Year = $year"
	echo -n "       Total sales = "
	grep -ir "^ J" SALESDATA/y$year | wc -l
	echo -n "       Total Odyssey sales = "
	grep -ir "^ J" SALESDATA/y$year | grep -iw ODYSSEY | wc -l
	echo -n "       Total July sales = "
	grep -ir "^ J" SALESDATA/y$year | grep -iw JUL | wc -l
	echo -n "       Total sales by Linda Carr = "
	grep -ir "^ J" SALESDATA/y$year | grep -iw "Carr, Linda" | wc -l
	echo ""
done

echo "Looking for sale of $vin"
echo -n "     "
for year in {2010..2015}
do
	grep -ir "^ $vin" SALESDATA/y$year

done
