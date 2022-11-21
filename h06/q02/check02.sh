#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"h06/q02")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/h06/q02

fi
anum="h06"		# (a|h|e)XX
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
        where=${where/'/h06/q02'//}
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
        	echo "Checking username, password and database name changes"
        	msg1="username and password changes    "
		msg3="createdb.sql changes             "
		msg4="database data values (in q02.txt)"
        	v1=1					# Set expected value for test 1
		v2=1
		v3=1
		v4=1
		v5=1
		v6=1
		n1=$( grep -i user= q02.sh | grep -ivc invalid_user )
		n2=$( grep -i pass= q02.sh | grep -ivc invalid_pass )
		n3=$( head -1 createdb.sql | grep -iwvc invalid_db )
		n4=0
		n5=0
		n6=0
		if [ -e q02.txt ]
		then
			n4=$( grep -iwc 2522 q02.txt )
			n5=$( grep -iwc 44 q02.txt )
			n6=$( grep -iwc 1 q02.txt )
		fi

		t1=$( [ $n1 -eq $v1 ] && [ $n2 -eq $v2 ] ; echo $? )	# Modify as needed
		nc=$(( $n2 + 100*$n1 ))
        	check $t1 $nc "$msg1"

        	t3=$( [ $n3 -eq $v3 ]; echo $? ) 	# Modify as needed
        	check $t3 $n3 "$msg3"
		echo ""

		echo "Checking database data insertion"
        	t4=$( [ $n4 -eq $v4 ] && [ $n5 -eq $v5 ] && [ $n6 -eq $v6 ] ; echo $? ) 	# Modify as needed
		nc=$(( $n6 + 100*($n5+100*$n4) ))
        	check $t4 $nc "$msg4"
        	echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

