#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a07/q01")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a07/q01

fi
anum="a07"		# (a|h|e)XX
qnum="q01"		# qXX
rnum="01"		# text for question number
#
#
script=$qdir/q01.sh
script2=$qdir/script01.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/a07/q01'//}
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

        echo "Checking for q01.sh"
        if [ -e q01.sh ]
        then
                msg1="q01.sh found                        "
		n1=1
        else
                msg1="q01.sh not found                    "
		n1=0
        fi
	t1=$( [ -e q01.sh ]; echo $? )
	check $t1 $n1 "$msg1"
        echo ""
        echo "Checking to see that all environment variables have been set"
        msg2="env_mysql does not exist in q01"
	nt=0;
	t2=$( [ -e env_mysql ] ; echo $? )
        if [ -e env_mysql ]
        then
                n1=$(grep MYSQLU  env_mysql | grep export | wc -l)
                n2=$(grep MYSQLP  env_mysql | grep export | wc -l)
                n3=$(grep REPORTS env_mysql | grep export | wc -l)
                n4=$(grep ARCHIVE  env_mysql | grep export | wc -l)
                nt=$((n1+n2+n3+n4))
		t2=$( [ $nt -eq 4 ]; echo $? )
                if [ $nt -eq 4 ] 
                then
                        msg2="all environment variables set in q01"
                else
                        msg2="not all envirionment varaibles set in q01 ($n1 $n2 $n3 $n4)"
                fi
        fi
	check $t2 $nt "$msg2"

        Q01=$(pwd)
        nt=0
	msg=""
        for dir in q02 q03 q04 q05
        do
		msq=""
	        msg="env_mysql does not exist in $dir"
		nt=0
		t2=$( [ -e ../$dir/env_mysql ] ; echo $? )
        	if [ -e ../$dir/env_mysql ]
        	then
                	n1=$(grep MYSQLU  ../$dir/env_mysql | grep export | wc -l)
                	n2=$(grep MYSQLP  ../$dir/env_mysql | grep export | wc -l)
                	n3=$(grep REPORTS ../$dir/env_mysql | grep export | wc -l)
                	n4=$(grep ARCHIVE  ../$dir/env_mysql | grep export | wc -l)
                	nt=$((n1+n2+n3+n4))
			t2=$( [ $nt -eq 4 ]; echo $? )
                	if [ $nt -eq 4 ] 
                	then
                        	msg="all environment variables set in $dir"
                	else
                        	msg="not all envirionment varaibles set in $dir ($n1 $n2 $n3 $n4)"
                	fi
        	fi
		check $t2 $nt "$msg"
        done
)

else
	echo "$script not found - INCOMPLETE SOLUTION"
fi
echo ""

