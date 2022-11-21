#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"h04/q04")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/h04/q04

fi
anum="h04"		# (a|h|e)XX
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
        where=${where/'/h04/q04'//}
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
        	echo "Testing script results"
        	msg1="Search count values"
        	v1=4				  # Set expected value for test 1
        	v2=4
	  	n1=$( $script story.txt  < test.in | grep -iwE "18|6|4430|278|0" | wc -l)
	        n2=$( $script check04.sh < test.in | grep -iwE "0|1|3|6" | wc -l)
	        c1=$(( n2 + 100*n1 ))
		t1=$( [ $n1 -eq $v1 ] && [ $n2 -eq $v2 ] ; echo $?)
        	check $t1 $c1 "$msg1"
		echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

