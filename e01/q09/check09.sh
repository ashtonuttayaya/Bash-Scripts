#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"e01/q09")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/e01/q09

fi
anum="e01"		# (a|h|e)XX
qnum="q09"		# qXX
rnum="09"		# text for question number
#
#
script=$qdir/q09.sh
script2=$qdir/script09.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/e01/q09'//}
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
	code="chx""q09-""${csym[$cindex]}"
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
        	echo "checking script performance"
        	msg1="terminal output when all files exist              "
		msg2="terminal output when some files missing           "
		msg3="headers.txt created                               "
		msg4="headers.txt content for valid files               "
		msg5="teminal ouput when all files missing              "
		msg6="headers.txt content when all files missing        "
		n1=$( $script s1.txt s3.txt s4.txt | grep -iv not | wc -l )	# should be 3
		n3=$( cat headers.txt | wc -l )					# should be 9
		n2=$( $script s1.txt sa.txt s4.txt | grep -iv not | wc -l )	# should be 2
		n4=$( cat headers.txt | wc -l )					# should be 6
		n5=$( $script sa.txt sb.txt sc.txt | grep -i not | wc -l )	# should be 3
		n6=$( cat headers.txt | wc -l )					# should be 0
        	t1=$( [ $n1 -eq 3 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
        	t2=$( [ $n2 -eq 2 ] ; echo $? )	# Modify as needed
        	check $t2 $n2 "$msg2"
        	t3=$( [ $n3 -eq 9 ] ; echo $? )	# Modify as needed
        	check $t3 $n3 "$msg3"
        	t4=$( [ $n4 -eq 6 ] ; echo $? )	# Modify as needed
        	check $t4 $n4 "$msg4"
        	t5=$( [ $n5 -eq 3 ] ; echo $? )	# Modify as needed
        	check $t5 $n5 "$msg5"
        	t6=$( [ $n6 -eq 0 ] ; echo $? )	# Modify as needed
        	check $t6 $n6 "$msg6"
        	echo ""
		$script s1.txt s3.txt s4.txt > /dev/null
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

