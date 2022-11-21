#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a03/q01")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a03/q01

fi
anum="a03"		# (a|h|e)XX
qnum="q01"		# qXX
rnum="01"		# text for question number
#
#
script=$qdir/q01.sh
script2=$qdir/script01.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/a03/q01'//}
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
        	echo "Looking for q01.sh and finder.in"
        	msg1="q01.sh and finder.in locations "
        	msg2="v00 backup                     "
        	msg3="v01 backup                     "
		msg4="success.log                    "
		msg5="error.log                      "
		msg6="change to input for file name  "
        	v1=1							# Set expected value for test 1
        	n1=1							# Execute commands to set n1
        	t1=$( [ -e q01.sh ]  && [ -e finder.in ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
		echo ""

        	echo "Looking for finder.sh backup files (versions 00 and 01)"
        	v2=1					# Set expected value for test 2
        	n2=1					# Execute command to set n2
        	t2=$( [ -e ~/backup/finder_v00.sh ]; echo $? ) 	# Modify as needed
        	check $t2 $n2 "$msg2"
        	v3=1					# Set expected value for test 2
        	n3=1					# Execute command to set n2
        	t3=$( [ -e ~/backup/finder_v01.sh ]; echo $? ) 	# Modify as needed
        	check $t3 $n3 "$msg3"
        	echo ""

        	$script < $qdir/finder.in > /dev/null 2> /dev/null
		echo "Checking log files"
		n4=0
		v4=2
		n5=0
		v5=2
		if [ -e success.log ]
		then
			n4=$( cat success.log | wc -l )
		fi
		if [ -e error.log ]
		then
			n5=$( cat error.log | wc -l )
		fi
	        t4=$( [ -e success.log ] && [ $n4 -gt $v4 ] ; echo $? )
	        t5=$( [ -e error.log ]   && [ $n5 -gt $v5 ] ; echo $? )
		check $t4 $n4 "$msg4"
		check $t5 $n5 "$msg5"
		echo ""
		echo "Checking for required changes"
		n6=1
		n7=0
		n6=$( grep -iE "^file=\"bin\"" $script | wc -l )
		n7=$( grep -iE "read\s*file" $script | wc -l )
		t6=$( [ $n6 -eq 0 ] && [ $n7 -gt 0 ] ; echo $? )
		n=$(( n7 + 10*n6 + 100 ))
		check $t6 $n "$msg6"
		echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

