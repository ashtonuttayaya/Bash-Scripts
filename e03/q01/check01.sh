#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"e03/q01")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/e03/q01

fi
anum="e03"		# (a|h|e)XX
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
        where=${where/'/e03/q01'//}
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
        	echo "Checking error processing"
        	msg1="No file(s) provided                            "
        	n1=$( $script | wc -l ) 				# Execute commands to set n1
        	t1=$( [ $n1 -lt 4 ] && [ $n1 -gt 0 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
        	msg1="Non-existent file provided                     "
        	n1=$( $script a01.bac | wc -l ) 			# Execute commands to set n1
        	t1=$( [ $n1 -lt 4 ] && [ $n1 -gt 0 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
        	echo ""

        	echo "Checking functionality"
        	msg2="Handles 1 or more files                        "
		n2=$( $script file1 file2 file3 file3 file4 file1 | grep -iE "Count" | grep -iE "6" | wc -l )	# should be 1
		n3=$( $script a01.bak | grep -iE "Count" | grep -iE "1" | wc -l )	# should be 1
        	t2=$( [ $n2 -eq 1 ] && [ $n3 -eq 1 ] ; echo $? ) 	# Modify as needed
		n=$(( n3 + 100*n2 ))
        	check $t2 $n "$msg2"
        	msg2="Count, Total, Min and Max output lines provided"
		n2=$( $script a01.bak | grep -iE "count|total|min|max" | wc -l )			# should be 4
		n3=$( $script a01.bak | grep -iE "1|320" | wc -l )					# should be 4
        	t2=$( [ $n2 -eq 4 ] && [ $n3 -eq 4 ]; echo $? ) 	# Modify as needed
		n=$((n3 + 100*n2 ))
        	check $t2 $n "$msg2"
        	msg2="Count, Total, Min and Max values are correct   "
		n2=$( $script file1 file2 file3 | grep -iE "3|25006|8014|8888" | wc -l )		# should be 4
		n3=$( $script a01.bak a01.bak | grep -iE "2|320|640" | wc -l )				# should be 4
        	t2=$( [ $n2 -eq 4 ] && [ $n3 -eq 4 ]; echo $? ) 	# Modify as needed
		n=$((n3 + 100*n2 ))
        	check $t2 $n "$msg2"
        	echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

