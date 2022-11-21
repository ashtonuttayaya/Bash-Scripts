#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"h09/q02")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/h09/q02

fi
anum="h09"		# (a|h|e)XX
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
        where=${where/'/h09/q02'//}
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
        	echo "Checking for all output values"
		f1=( file1.txt 8014 1466 124 8014 11.82 1.00 )
		f2=( file2.txt 8235 1451 168 8235 8.63 1.00 )
		f3=( file3.txt 8520 1559 174 8520 8.95 1.00 )
		arr1=( $($script file1.txt) )
		arr2=( $($script file2.txt) )
		arr3=( $($script file3.txt) )
        	msg1="Checking output length          "
        	n1=${#arr1[@]}				# Set expected value for test 1
        	v1=7					# Execute commands to set n1
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
        	msg1="Checking byte counts            "
        	n1="${arr3[4]}"				# Set expected value for test 1
        	v1="${f3[4]}"				# Execute commands to set n1
        	t1=$( [ "$n1" == "$v1" ] ; echo $? )	# Modify as needed
        	check $t1 "$n1" "$msg1"
        	msg1="Checking line counts            "
        	n1="${arr3[3]}"				# Set expected value for test 1
        	v1="${f3[3]}"				# Execute commands to set n1
        	t1=$( [ "$n1" == "$v1" ] ; echo $? )	# Modify as needed
        	check $t1 "$n1" "$msg1"
        	msg1="Checking avg. words/line values "
        	n1="${arr3[5]}"				# Set expected value for test 1
        	v1="${f3[5]}"				# Execute commands to set n1
        	t1=$( [ "$n1" == "$v1" ] ; echo $? )	# Modify as needed
        	check $t1 "$n1" "$msg1"

        	echo ""

        	echo "Checking for error processing"
        	msg2="Invalid or missing file test    "
        	v2=0					# Set expected value for test 2
        	n2=$( $script junk788n | grep -i "1.00" | wc -l )					# Execute command to set n2
 		n3=$( $script | grep -i "1.00" | wc -l )
		n=$(( 100*n2 + n3 ))
	       	t2=$( [ $n -eq $v2 ]; echo $? ) 	# Modify as needed
        	check $t2 $n2 "$msg2"
        	echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

