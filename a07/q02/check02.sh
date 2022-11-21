#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a07/q02")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a07/q02

fi
anum="a07"		# (a|h|e)XX
qnum="q02"		# qXX
rnum="02"		# text for question number
#
#
script=$qdir/q02.sh
script2=$qdir/script02.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/a07/q02'//}
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
	code="chx""q02-""${csym[$cindex]}"
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
	echo "Checking script q02.sh performance"

#
#       Changed to simply making sure script is returning numbers, not 0's
#
	msg1=""
	msg2=""
	msg3=""
        n1=$($script 2013 Fit all 2>/dev/null | wc -w)
        narray=( $($script 2013 Fit all 2>/dev/null | grep -w 2013) )
        nt=$n1
        for i in {0..4}
        do
                if [ ${narray[$i]} -gt 0 ]
                then
                        nt=$((nt+1))
                fi
        done


	t1=$( [ $nt -eq 10 ]; echo $? )
	if [ $nt -eq 10 ]
	then
		msg1="passed test for all car sales "
	else
		msg1="failed test for all car sales "
	fi
	check $t1 $nt "$msg1"

#
#       Changed to simply making sure script is returning numbers, not 0's
#
        n1=$($script 2013 Fit new 2> /dev/null | wc -w)
        narray=( $($script 2013 Fit new 2>/dev/null | grep -w 2013) )
        nt=$n1
        for i in {0..4}
        do
                if [ ${narray[$i]} -gt 0 ]
                then
                        nt=$((nt+1))
                fi
        done
	t2=$( [ $nt -eq 10 ]; echo $? )
	if [ $nt -eq 10 ]
	then
		msg2="passed test for new car sales "
	else
		msg2="failed test for new car sales "
	fi
	check $t2 $nt "$msg2"
#
#       Changed to simply making sure script is returning numbers, not 0's
#
        n1=$($script 2013 Fit used 2>/dev/null | wc -w)
        narray=( $($script 2013 Fit used 2>/dev/null | grep -w 2013) )
        nt=$n1
        for i in {0..4}
        do
                if [ ${narray[$i]} -gt 0 ]
                then
                        nt=$((nt+1))
                fi
        done

	t3=$( [ $nt -eq 10 ]; echo $? )
	if [ $nt -eq 10 ]
	then
		msg3="passed test for used car sales"
	else
		msg3="failed test for used car sales"
	fi
	check $t3 $nt "$msg3"
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi
echo ""
