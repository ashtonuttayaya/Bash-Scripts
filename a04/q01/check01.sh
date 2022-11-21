#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a04/q01")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a04/q01

fi
anum="a04"		# (a|h|e)XX
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
        where=${where/'/a04/q01'//}
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
		echo "Checking mysql modifications"
		msg2="mysqld_safe status (should no longer be running)"
		v2=0
                n2=`ps -aef | grep -v "grep" | grep -i "mysqld_safe" | wc -l`
        	t2=$( [ $n2 -eq $v2 ] ; echo $? )	# Modify as needed
        	check $t2 $n2 "$msg2"

		msg1="mysqld restart                                  "
		n1=`ps -aef | grep -v "grep" | grep -i "/usr/sbin/mysqld" | wc -l`
		v1=1
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
		echo ""
		echo -n "Confirming mysqld process status - "
                ps -aef | grep -v "grep" | grep -i --color=auto "mysql"
        	echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

