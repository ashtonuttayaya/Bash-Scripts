#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a06/q02")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a06/q02

fi
anum="a06"		# (a|h|e)XX
qnum="q02"		# qXX
rnum="02"		# text for question number
#
#
script=$qdir/check02.sh
script2=$qdir/script02.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/a06/q02'//}
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
cat > .cdev << DEVDB
use dev;
show tables;
DEVDB
	        echo "Checking for env_mysql"
		msg0="found env_mysql      "
		n0=1
		v0=1
		if [ ! -e env_mysql ]
		then
			n0=0
			msg0="did not find env_mysql"
		fi
		t0=$( [ -e env_mysql ] ; echo $? )
		check $t0 $n0 "$msg0"
		echo ""

	        echo "Checking for dev database creation"
		n1=0
		v1=10
		msg1="could not find env_mysql - no check done"
        	if [ -e env_mysql ]
        	then
			msg1="dev database created          "
                	source env_mysql
                	mysql -u $MYSQLU -p$MYSQLP < .cdev > .cdevout 2>.cdeverr
                	n1=$(cat .cdevout | grep -v sales_2016 | egrep -i "^sales_2|^Tables_in_dev$|^agents$|^owners$|^dealers$" | wc -l)
			t1=$( [ $n1 -eq $v1 ] ; echo $? )
			if [ $n1 -ne $v1 ]
			then
                	        cat .cdevout
                	fi
                	rm .cdevout
        	fi
		check $t1 $n1 "$msg1"
		n2=$(grep -iv warning .cdeverr | wc -l )
		msg2="Errors in database creation    "
		if [ $n2 -eq 0 ]
		then
			rm .cdeverr
			msg2="No errors in database creation"
		fi
		t2=$( [ $n2 -eq -0 ]; echo $? )
		check $t2 $n2 "$msg2"
        	echo ""
        	rm .cdev 
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

