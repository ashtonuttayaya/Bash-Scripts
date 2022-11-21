#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"e03/q02")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/e03/q02

fi
anum="e03"		# (a|h|e)XX
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
        where=${where/'/e03/q02'//}
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
        	echo "Checking sed changes"
		$script > .output
        	msg1="Replacement of KEY               "
        	v1=64						# Set expected value for test 1
        	n1=$(diff backup target | grep -i "Answer Key" | wc -l )	# Execute commands to set n1
        		echo $n1 >> .output		##########
		t1=$( [ $n1 -eq $v1 ] ; echo $? )		# Modify as needed
        	check $t1 $n1 "$msg1"
        	msg1="Replacement of OK                "
        	v1=13					# Set expected value for test 1
        	n1=$( diff backup target | grep -i "Great!" | wc -l )	# Execute commands to set n1
			echo $n1 >> .output
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
        	msg1="Total replacements               "
        	v1=290					# Set expected value for test 1
        	n1=$( diff backup target | wc -l )	# Execute commands to set n1
			echo $n1 >> .output
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
        	msg1="Change report - all, OK, and KEY "
        	v1=3					# Set expected value for test 1
        	n1=$( grep -iEo "64|13|0" .output | wc -l )	# Execute commands to set n1
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
		echo ""
		rm .output
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

