#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a07/q03")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a07/q03

fi
anum="a07"		# (a|h|e)XX
qnum="q03"		# qXX
rnum="03"		# text for question number
#
#
script=$qdir/q03.sh
script2=$qdir/script03.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/a07/q03'//}
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
	code="chx""q03-""${csym[$cindex]}"
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

	echo "Checking script q03.sh performance"
	$script Accord > /dev/null 2>/dev/null
	msg1=""
	n0=0;
	if [  -e report.tmp ]
	then
		n0=$(grep -wE '2010|2011|2012|2013|2014|2015' report.tmp | wc -l)
#
#       Changed to simply making sure script is returning numbers, not 0's
#
	        n1=$(grep -w 2011 report.tmp | wc -w)
		n2=$(grep -w 2010 report.tmp | wc -c)
		n3=$(grep -w 2015 report.tmp | wc -c)
        	narray=( $(grep -w 2012 report.tmp ) )
	else
		echo "report.tmp is missing, check aborted."
	fi
	t1=$( [ $n0 -eq 18 ]; echo $? )
	if [ $n0 -eq 18 ]
	then
		msg1="report.tmp contains all years for all, new and used car sales by model "
	else
		msg1="report.tmp does not contain all years for all, new and used car sales by model"
	fi
        	check $t1 $n0 "$msg1"

        nt=n1
        for i in {0..14}
        do
                if [ ${narray[$i]} -gt 0 ]
                then
                        nt=$((nt+1))
                fi
        done
	t2=$( [ $nt -eq 30 ]; echo $? )
	if [ $nt -eq 30 ]
	then
		msg2="passed test for sales by model                                         "
	else
		msg2="failed test for sales by model                                         "
	fi
	check $t2 $nt "$msg2"

	nz=$(( narray[1] - narray[6] - narray[11] ))
	if [ $nz -eq 0 ]
	then
		msgz="passed sum rule test: Total = New + Used                               "
	else
		msgz="failed sum rule test                                                   "
	fi
	tz=$( [ $nz -eq 0 ]; echo $? )
	check $tz $nz "$msgz"
	tf=$( [ $n2 -eq $n3 ]; echo $? )
	if [ $n2 -eq $n3 ]
	then
		msgf="passed report fixed line length test                                   "
	else
		msgf="failed report fixed line length test                                   "
	fi
	nf=$(( n2 - n3 ))
	check $tf $nf "$msgf"

#
#	Make sure we don't find a Camry
#
	nt0=$($script Camry 2>/dev/null | wc -l)
	nmt=0
	if [ -e report.tmp ]
	then
		nmt=1
	fi

	msg5=""
	nc=$(( nmt+10*nt0 ))
#	echo "$nc nmt=$nmt nt0=$nt0"
	t5=$( [ $nmt -eq 0 ] && [ $nt0 -ge 0 ]  ; echo $? )
	if [ $nmt -eq 0 ] && [ $nt0 -ge 0 ]
	then
		msg5="passed invalid parameter test                                          "
	else
		msg5="failed invalid parameter test                                          "
	fi
	check $t5 $nc "$msg5"

        	echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

