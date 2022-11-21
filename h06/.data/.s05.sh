#!/bin/bash
type=$1
output="q05.sql"
echo "use h6_fml_lcd;" > $output
echo "select count(*) from students;" >> $output

if [ $type == "Y" ]
then
	for year in 1 2 3 4 5 6
	do
		echo "select count(*) from students where year=\"$year\";" >> $output
	done

elif [ $type == "G" ]
then
	for gender in 1 2
	do
		echo "select count(*) from students where gender=\"$gender\";" >> $output
	done
else 
	echo "ERROR - parameter should be Y or G"

	rm $output
fi
