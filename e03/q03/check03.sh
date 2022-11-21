#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"e03/q03")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/e03/q03

fi
anum="e03"		# (a|h|e)XX
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
        where=${where/'/e03/q03'//}
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
        	echo "Checking error handling"
        	msg1="File name not provided            "
        	v1=0					# Set expected value for test 1
		n1=$($script | grep -E "[0-9]" |  wc -l )
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
        	msg1="File not found                    " 
        	v1=0					# Set expected value for test 1
		n1=$($script junk.txt | grep -E "[0-9]" |  wc -l )
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
        	echo ""

        	echo "Checking functionality"
        	msg1="Checking differences found        "
        	v1=1					# Set expected value for test 1
		n1=$($script file1.txt | grep -iw "7" |  wc -l )
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
        	msg1="Checking line numbers             "
        	v1=1					# Set expected value for test 1
		n1=$($script standard.txt | grep -iw "251" |  wc -l )
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
        	msg1="Checking perdentages              "
        	v1=1					# Set expected value for test 1
		n1=$($script file1.txt | grep -w "2.72" |  wc -l )
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
        	echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

