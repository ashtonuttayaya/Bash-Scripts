#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"h04/q03")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/h04/q03

fi
anum="h04"		# (a|h|e)XX
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
        where=${where/'/h04/q03'//}
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
        	echo "Testing valid input"
        	msg1="default search   "
        	msg2="basic search     "
		msg5="mixed search     "
        	v1=110				  # Set expected value for test 1
		n1=$( $script nothing < test.in | wc -l )
		n2=$( $script very < test.in | grep -i much | wc -l )
		n5=$( $script nothing < test.in | grep -i very | wc -l)

        	t1=$( [ $n1 -eq $v1 ] ; echo $? ) # Modify as needed
        	check $t1 $n1 "$msg1"
        	v2=27				 # Set expected value for test 2
        	t2=$( [ $n2 -eq $v2 ]; echo $? ) # Modify as needed
        	check $t2 $n2 "$msg2"
        	v5=6
        	t5=$( [ $n5 -eq $v5 ]; echo $? ) # Modify as needed
        	check $t5 $n5 "$msg5"
        	echo ""

        	echo "Testing invalid input"
        	msg3="missing word test"
        	msg4="missing file test"
        	msg6="missing both test"
        	v3=1
		v4=1
		v6=1
		n3=$( $script < test.in | tail -1 | grep -iE "exit|abort|quit" | wc -l )
		n4=$( $script puzzle < no.in | tail -1 | grep -iE "exit|abort|quit" | wc -l )
		n6=$( $script < no.in | tail -1 | grep -iE "exit|abort|quit" | wc -l )
        	t3=$( [ $n3 -eq $v3 ]; echo $? ) # Modify as needed
        	t4=$( [ $n4 -eq $v4 ]; echo $? ) # Modify as needed
		check $t3 $n3 "$msg3"
		check $t4 $n4 "$msg4"
        	t6=$( [ $n6 -eq $v6 ]; echo $? ) # Modify as needed
		check $t6 $n6 "$msg6"
        	echo ""


	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

