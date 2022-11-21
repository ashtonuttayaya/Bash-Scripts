#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"h08/q02")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/h08/q02

fi
anum="h08"		# (a|h|e)XX
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
        where=${where/'/h08/q02'//}
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
        	echo "Checking valid output values"
# Looking for correct count line
        	msg1="Count value  "
        	v1=1					# Set expected value for test 1
		$script 4 3 3 10 20 105 > .out
        	n1=$( cat .out | grep -i count | grep -iwE "=6|6|count=6" | wc -l)
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"

# Looking for correct sum line
        	msg1="Sum value    "
        	v1=1					# Set expected value for test 1
        	n1=$( cat .out | grep -i sum | grep -iwE "145|=145|sum=145" | wc -l)
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
# Looking for correct min line
        	msg1="Min value    "
        	v1=1					# Set expected value for test 1
        	n1=$( cat .out | grep -i min | grep -iwE "3|=3|min=3" | wc -l)
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
# Looking for correct max line
        	msg1="Max value    "
        	v1=1					# Set expected value for test 1
        	n1=$( cat .out | grep -i max | grep -iwE "105|=105|max=105" | wc -l)
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
        	echo ""

        	echo "Checking invalid input"
        	msg2="Exit on error"
		$script > .out
        	v2=0					# Set expected value for test 2
        	n2=$( cat .out | grep -iE "count|sum|min|max" | wc -l )					# Execute command to set n2
        	t2=$( [ $n2 -eq $v2 ]; echo $? ) 	# Modify as needed
        	check $t2 $n2 "$msg2"
        	echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

