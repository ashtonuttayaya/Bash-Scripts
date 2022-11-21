#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"h04/q05")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/h04/q05

fi
anum="h04"		# (a|h|e)XX
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
        where=${where/'/h04/q05'//}
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
		echo "Checking input error protection"
		msg1="file type checks      "
		msg2="missing file check    "
		$script quizzes.sql test.sql > /dev/null
        	n1=0
		v1=0
        	if [ -e test.sql ]
        	then
                	n1=$( cat test.sql | wc -l ) 
                	rm test.sql
        	fi

        	$script quizzes.dat test.dat > /dev/null
        	n3=0
		v3=0
        	if [ -e test.dat ]
        	then
        	        n3=1
        	        rm test.dat
        	fi
		t1=$( [ $n1 -eq $v1 ] && [ $n3 -eq $v3 ] ; echo $? )
		c1=$(( n3 + 100*n1 ))
		check $t1 $c1 "$msg1"

        	$script junk.dat test.sql > /dev/null
		v2=0
	        n2=0
	        if [ -e test.sql ]
	        then
	                n2=1
	                rm test.sql
	        fi

        	t2=$( [ $n2 -eq $v2 ] ; echo $? ) 
		check $t2 $n2 "$msg2"
		echo ""

		echo "Checking normal operation"
		$script quizzes.dat test.sql > /dev/null
        	n4=0
        	if [ -e $qdir/test.sql ]
        	then
        	        n4=$( cat test.sql | wc -l ) 
        	        rm test.sql
        	fi

		$script update.dat test.sql > /dev/null 
	        n5=0
	        if [ -e test.sql ]
	        then
	                n5=$( cat test.sql | wc -l )
	                rm test.sql
	        fi
        	msg4="quizzes & update tests"
        	v4=65
        	v5=37
		c4=$(( v5 + 100*v4 ))
        	t4=$( [ $n4 -eq $v4 ] && [ $n5 -eq $v5 ] ; echo $? )
        	check $t4 $c4 "$msg4"
        	echo ""

	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

