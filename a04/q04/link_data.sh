#!/bin/bash
#
#
dir=$(pwd)
flag=`echo $dir|awk '{print match($0,"a04/q04")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a04/q04

fi
rm $qdir/SALESDATA 2> /dev/null
rm $qdir/*.sql 2> /dev/null
odir="${qdir/q04/q03}" 
data="$odir/""SALESDATA"
asql="$odir/""agents.sql"
dsql="$odir/""dealers.sql"
osql="$odir/""owners.sql"
if [ -e $data ]
then

	ln -s $data SALESDATA
else
	echo "$data is missing, could not link to it"
	echo "Make sure q03 completed correctlty"
fi
if [ -e $asql ]
then
	ln -s $asql agents.sql
else
	echo "$asql is missing, could not link to it"
	echo "Make sure q03 completed correctlty"
fi
if [ -e $dsql ]
then 
	ln -s $dsql dealers.sql
else
	echo "$dsql is missing, could not link to it"
	echo "Make sure q03 completed correctlty"
fi
if [ -e $osql ]
then
	ln -s $osql owners.sql
else
	echo "$osql is missing, could not link to it"
	echo "Make sure q03 completed correctlty"
fi
