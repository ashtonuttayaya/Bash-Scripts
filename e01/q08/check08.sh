#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"e01/q08")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/e01/q08

fi
anum="e01"		# (a|h|e)XX
qnum="q08"		# qXX
rnum="08"		# text for question number
#
#
script=$qdir/q08.sh
script2=$qdir/script08.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/e01/q08'//}
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
	code="chx""q08-""${csym[$cindex]}"
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
        	echo "Checking script behavior under different conditions"
		echo "s1.txt" > .s1
		echo "s2.txt" > .s2
		echo "null.txt" > .null
        	msg1="Reading filename                         "
        	msg2="Existence Check                          "
        	msg3="Output Check                             "
        	msg4="Graceful exit                            "
		n1=$( $script < .s1 | wc -l )

        	t1=$( [ $n1 -ge 3 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"

		n2=$( $script < .null | grep -i not | grep -i "exist" |  wc -l )
        	t2=$( [ $n2 -eq 1 ]; echo $? ) 	# Modify as needed
        	check $t2 $n2 "$msg2"

		n3=$( $script < .s2 | grep -i good | wc -l )
        	t3=$( [ $n3 -eq 8 ]; echo $? ) 	# Modify as needed
        	check $t3 $n3 "$msg3"

		n4=$( $script < .null |  tail -n 1 | grep -i not | grep -i exist | wc -l )
        	t4=$( [ $n4 -eq 1 ]; echo $? ) 	# Modify as needed
        	check $t4 $n4 "$msg4"
        	echo ""
		rm .s1 .s2 .null
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

