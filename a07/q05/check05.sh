#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a07/q05")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a07/q05

fi
anum="a07"		# (a|h|e)XX
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
        where=${where/'/a07/q05'//}
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
echo "Checking for reports and archived tar file - please wait"
if [ -e $script ]
then
	(
        	cd $qdir
	msg1=0
	t1=$([ ! -e evn_mysql ]; echo $? )
	if [ ! -e env_mysql ]
	then
		msg1="Environment setup file missing"
		check $t1 0 "$msg1"
		exit
	fi
	source env_mysql
	$script 2>/dev/null

	n1=$(ls $REPORTS/*.txt | wc -w)
	t2=$( [ $n1 -ge 10 ]; echo $?)
	if [ $n1 -ge 10 ]
	then
		msg2="all reports present                  "
	else
		msg2="some reports missing                 "
	fi
	check $t2 $n1 "$msg2"

	n1=$(ls ~/archive/models.tar | wc -l)
	t2=$( [ $n1 -eq 1 ]; echo $?)
	if [ $n1 -eq 1 ]
	then
		msg2="models.tar file found in archive     "
	else
		msg2="models.tar file not found in archive "
	fi
	check $t2 $n1 "$msg2"

	n1=$( tar -tvf ~/archive/models.tar | wc -l)

	t3=$( [ $n1 -eq 10 ] ; echo $? )
	if [ $n1 -eq 10 ]
	then
		msg3="all model reports archived           "
	else
		msg3="some model reports not archived      "
	fi
	check $t3 $n1 "$msg3"
        echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

