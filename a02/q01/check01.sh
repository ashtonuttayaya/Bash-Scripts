#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a02/q01")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a02/q01

fi
anum="a02"		# (a|h|e)XX
qnum="q01"		# qXX
rnum="01"		# text for question number
#
#
script=$qdir/check01.sh
script2=$qdir/script01.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/a02/q01'//}
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
	code="chx""q01-""${csym[$cindex]}"
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
        	echo "Checking for required executable files"
        	msg1="solution.pl         "
        	msg2="decode.sh           "
        	msg3="results.txt location"
        	msg4="results.txt content "
        	v1=1
        	if [ -x solution.pl ]
		then
			n1=1
		else
			n1=0
		fi
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )
        	check $t1 $n1 "$msg1"

        	v2=1
        	if [ -x decode.sh ]
		then
			n2=1
		else
			n2=0
		fi
        	t2=$( [ $n2 -eq $v2 ] ; echo $? )
        	check $t2 $n2 "$msg2"
        	echo ""

        	echo "Checking results.txt"

        	v3=1
        	if [ -e results.txt ]
		then
			n3=1
		else
			n3=0
		fi

        	t3=$( [ $n3 -eq $v3 ]; echo $? ) # Modify as needed
        	check $t3 $n3 "$msg3"

        	v4=63
		v5=4
        	if [ -e results.txt ]
		then
			n4=$( cat results.txt | wc -l)
			n5=$( grep -iow Florida results.txt | wc -l)
		else
			n4=0
			n5=0
		fi
		c4=$(( n4 + 100 * n5))
        	t4=$( [ $n4 -eq $v4 ] && [ $n5 -eq $v5 ] ; echo $? ) # Modify as needed
        	check $t4 $c4 "$msg4"

        	echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

