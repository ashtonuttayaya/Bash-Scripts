#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"h06/q05")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/h06/q05

fi
anum="h06"		# (a|h|e)XX
qnum="q05"		# qXX
rnum="10"		# text for question number
#
#
script=$qdir/q05.sh
script2=$qdir/script10.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/h06/q05'//}
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
	code="chx""q05-""${csym[$cindex]}"
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
        	echo "Checking option Y"
		$script Y
	        if [ -e q05.sql ]
        	then
			n1=$(cat q05.sql | sed -e 's/\s+/ /g' | grep -i select | grep -i count | grep -iw "from students" | grep -i "where year" | wc -l)
                	n2=$(cat q05.sql | sed -e 's/\s+/ /g' | grep -i select | grep -i count | grep -iw "from students" | grep -i "where year" | grep -iE "[1-6]" | wc -l)
		else
			n1=-1
			n2=-1
		fi
        	msg1="# of sql statements"
        	msg2="query by year      "
        	v1=6					# Set expected value for test 1
        	v2=6					# Set expected value for test 2
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
        	t2=$( [ $n2 -eq $v2 ] ; echo $? ) 	# Modify as needed
        	check $t2 $n2 "$msg2"
        	echo ""

		echo "Checking option G"
		$script G
		if [ -e q05.sql ]
		then
                	n3=$(cat q05.sql | sed -e 's/\s+/ /g' | grep -i select | grep -i count | grep -iw "from students" | grep -i "where gender" | wc -l)
                	n4=$(cat q05.sql | sed -e 's/\s+/ /g' | grep -i select | grep -i count | grep -iw "from students" | grep -i "where gender" | grep -i 1 | wc -l)
                	n5=$(cat q05.sql | sed -e 's/\s+/ /g' | grep -i select | grep -i count | grep -iw "from students" | grep -i "where gender" | grep -i 2 | wc -l)
		else
			n3=-1
			n4=-1
			n5=-1
		fi
		msg3="# of sql statements"
		msg4="query by gender    "
		t3=$( [ $n3 -eq 2 ] ; echo $? )
		nc=$(($n5 + 100*$n4))
		t4=$( [ $n4 -eq 1 ] && [ $n5 -eq 1 ] ; echo $? )
		check $t3 $n3 "$msg3"
		check $t4 $nc "$msg4"
		echo ""

		echo "Checking invalid option"
	        niv=$($script T | wc -l)
        	t6=$( [ ! -e q05.sql ] && [ $niv -gt 0 ] ; echo $? )
		msg6="for bad parameter  "
		check $t6 $niv "$msg6"
		echo ""

	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

