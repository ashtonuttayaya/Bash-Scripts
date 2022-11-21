#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"h05/q05")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/h05/q05

fi
anum="h05"		# (a|h|e)XX
qnum="q05"		# qXX
rnum="05"		# text for question number
#
#
script=$qdir/q05.sh
script2=$qdir/script05.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/h05/q05'//}
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
        	echo "Testing options"
        	msg1="E option check      "
        	msg2="H option check      "
        	msg3="Q option check      "
		msg4="Invalid option check"
        	v1=2
		v2=2
		v3=2
		v4=1
	        n1=$($script E 34 | grep 49  | grep -i exam | grep 34 | wc -l)
        	n2=$($script H 4  | grep 926 | grep -i home | grep 4  | wc -l)
        	n3=$($script Q 8  | grep 286 | grep -i quiz | grep 8  | wc -l)
      		n4=$($script T 8 | wc -l )
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
        	t2=$( [ $n2 -eq $v2 ] ; echo $? )	# Modify as needed
        	check $t2 $n2 "$msg2"
        	t3=$( [ $n3 -eq $v3 ] ; echo $? )	# Modify as needed
        	check $t3 $n3 "$msg3"
        	t4=$( [ $n4 -eq $v4 ] ; echo $? )	# Modify as needed
        	check $t4 $n4 "$msg4"
        	echo ""

	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

