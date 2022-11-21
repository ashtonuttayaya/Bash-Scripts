#!/bin/bash
flag=$1
score=$2
textfile="insert_data.txt"
sqlfile="insert_data.sql"
#
#	Set the search strings for TXT files
#
texam="TYPE=EX"
tquiz="TYPE=QU"
thwrk="TYPE=HW"
tscore="SCORE=$2"
#
#	Set the search strings for SQL files
#
sexam="'EX',"
squiz="'QU',"
shwrk="'HW',"
sscore="'$2');"

if [ $flag == "H" ]
then
nt=`grep -i $thwrk $textfile | grep -i $tscore | wc -l` 
echo "(TXT) Homework score = $score count = $nt"
echo
ns=`grep -i $shwrk $sqlfile | grep -i $sscore | wc -l` 
echo "(SQL) Homework score = $score count = $ns"

elif [ $flag == "Q" ]
then
nt=`grep -i $tquiz $textfile | grep -i $tscore | wc -l` 
echo "(TXT) Quiz score = $score count = $nt"
echo
ns=`grep -i $squiz $sqlfile | grep -i $sscore | wc -l` 
echo "(SQL) Quiz score = $score count = $ns"

elif [ $flag == "E" ]
then
nt=`grep -i $texam $textfile | grep -i $tscore | wc -l` 
echo "(TXT) Exam score = $score count = $nt"
echo
ns=`grep -i $sexam $sqlfile | grep -i $sscore | wc -l` 
echo "(SQL) Exam score = $score count = $ns"

else
echo "The parameter is not H, Q or E"
exit
fi

