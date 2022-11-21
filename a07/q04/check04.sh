#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a07/q04")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a07/q04

fi
anum="a07"		# (a|h|e)XX
qnum="q04"		# qXX
rnum="04"		# text for question number
#
#
script=$qdir/q04.sh
script2=$qdir/script04.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/a07/q04'//}
        if [ -e $where/testing ]
        then
                testing=1
		if [ -e $script2 ]
		then
                	cp $script2 $script
		else
			touch $script
		fi
        else
                testing=0
        fi
fi
#
#	Set standard functions for checking routines
#
cindex=0
csym=( A B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI AJ AK AL AM AN AO AP AQ AR AS AT AU AV AW AX AY AZ )

check () {
        setcode
        t=$1
        n=$2
        msg="$3"
        if [ $t -eq 0 ]
        then
                say_OK "$msg"
        else
                say_NOK "$msg" $n
        fi
}

setcode() {
	code="chx""q04-""${csym[$cindex]}"
	cindex=$(( cindex + 1 ))
}
say_OK () {
	main="$1"
	printf "%-10s OK - %s         %25s1\n" " " "$main" $code
}
say_NOK () {
	main="$1"
	printf "%-10s Not OK - %s ( %s ) %25s0\n" " " "$main" $2 $code
}

#
#	Customize this output for the particular script or activity
#

if [ -e $script ]
then
	(
	cd $qdir
	echo "Checking script performance"
	$script Odyssey > /dev/null 2>/dev/null
	n0=$(grep -wE '2010|2011|2012|2013|2014|2015' report.tmp | wc -l)
	t0=$( [ $n0 -eq 18 ]; echo $? )
	if [ $n0 -eq 18 ]
	then
		msg0="report.tmp contains all years for all, new and used car sales by model "
	else
		msg0="report.tmp does not contain all years for all, new and used car sales by model "
	fi
	check $t0 $n0 "$msg0"
	n1=$(grep -w 2011 report.tmp | wc -w)
	n2=$(grep -w 2010 report.tmp | wc -c )
	n3=$(grep -w 2015 report.tmp | wc -c )
	nt=$n1
#
#       Changed to simply making sure script is returning numbers, not 0's
#
        n1=$(grep -w 2011 report.tmp | wc -w)
        narray=( $(grep -w 2013 report.tmp ) )
        nt=$n1
#	echo "${narray[@]}"
        for i in 0 1 2 3 4 5 6 9 10 11 12 13 14 15 18 19 20 21 22 23 24
        do
                if [ ${narray[$i]} -gt 0 ]
                then
                        nt=$((nt+1))
#			echo "$n1 $nt"
                fi
        done
        for i in 7 8 16 17 25 26
        do
                if [ ! -z "${narray[$i]}" ]
                then
                        nt=$((nt+1))
#			echo "$n1 $nt"
                fi
        done
	msg1=""
	t1=$( [ $nt -eq 54 ]; echo $? )
	if [ $nt -eq 54 ]
	then
		msg1="passed test for sales by model                                         "
	else
		msg1="failed test for sales by model                                         "
	fi
	check $t1 $nt "$msg1"
#
#	Checking for fixed length output lines
#
	if [ $n2 -eq $n3 ]
	then
		msgo="report contains fixed length output data                               "
	else
		msgo="report does not have fixed length output data                          "

	fi
	no=$(( n2 - n3 ))
	to=$( [ $n2 -eq $n3 ]; echo $?)
	check $to $no "$msgo"
	echo ""

	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

