#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a06/q01")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a06/q01

fi
anum="a06"		# (a|h|e)XX
qnum="q01"		# qXX
rnum="01"		# text for question number
#
#
script=$qdir/check01.sh
script2=$qdir/script01.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/a06/q01'//}
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
		echo "Checking for sales_v6100.sql and sales_v6100.txt"
        	msg1="Found sales_v6100.txt"
        	n1=1					# Execute commands to set n1
		v1=1
        	if [ ! -e sales_v6100.txt ] 
		then
			msg1="Did not find sales_v6100.txt"
			n1=0
		fi
        	t1=$( [ -e sales_v6100.txt ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"

        	msg2="Found sales_v6100.sql"
        	n2=1
		v2=1
        	if [ ! -e sales_v6100.sql ] 
		then
			msg2="Did not find sales_v6100.sql"
	        	n2=0
		fi
        	t2=$( [ -e sales_v6100.sql ] ; echo $? )	# Modify as needed
        	check $t2 $n2 "$msg2"

        	echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

