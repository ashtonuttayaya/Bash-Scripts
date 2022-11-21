#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"e02/q06")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/e02/q06

fi
anum="e02"		# (a|h|e)XX
qnum="q06"		# qXX
rnum="06"		# text for question number
#
#
script=$qdir/q06.sh
script2=$qdir/script06.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/e02/q06'//}
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
	code="chx""q06-""${csym[$cindex]}"
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
		nc=$($script | grep "rpt" | wc -l)
		nc1=$($script | grep "rpt" | grep 739 | wc -l )
		nok=$($script | grep -w "OK\s*" | wc -l)
		nts=$($script | grep -w "TOO SHORT\s*" | wc -l)
		ntl=$($script | grep -w "TOO LONG\s*" | wc -l)
		n2=$($script | grep "2\s*$" | wc -l)
		n3=$($script | grep  "3\s*$" | wc -l)
		n5=$($script | grep  "5\s*$" | wc -l)
		n27=$($script | grep "27\s*$" | wc -l)
		n91=$($script | grep "91\s*$" | wc -l)
#	echo "$nc $nok $nts $ntl $n2 $n3 $n5 $n27 $n91"
		msgc="check all reports                 "
		msgr="evaluating report lengths         "
		msg1="finding \"the\" word                "
		msg2="finding words in special locations"

		tc=$( [ $nc -eq 8 ] ; echo $? )
		check $tc $nc "$msgc"
		tr=$( [ $nok -eq 3 ] && [ $nts -eq 2 ] && [ $ntl -eq 3 ] ; echo $? )
		nr=$(( $ntl + 10 * ( $nts + 10 * $nok) )) 
		check $tr $nr "$msgr"
		t1=$( [ $n27 -eq 1 ] && [ $n91 -eq 1 ] ; echo $? )
		n1=$(( $n91 + 10 * $n27 ))
		check $t1 $n1 "$msg1"
		t2=$( [ $n2 -eq 4 ] && [ $n3 -eq 1 ] && [ $n5 -eq 1 ] ; echo $? )
		n2=$(( ( $n5 + 10 * ($n3 + 10*($n2) ) ) ))
		check $t2 $n2 "$msg2"
		echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

