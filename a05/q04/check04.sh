#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a05/q04")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a05/q04

fi
anum="a05"		# (a|h|e)XX
qnum="q04"		# qXX
rnum="04"		# text for question number
#
#      0     1     2     3     4     5     6     7     8     9    10    11    12    13   14    15    16    17    18    19    20   21   22     23  24    25    26    27
a=(59123 66144 69471 72904 76544 79664 89492 14967 15175 15779 16441 16816 16982 19303 6498  5658  5923  6198  6499  6836  7601  130   184   118   149   142   131   302)
a1=2
a2=18
a3=11
a4=26
#
script=$qdir/q04.sh
script2=$qdir/script04.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/a05/q04'//}
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
	code="chx""q04-""${csym[$cindex]}"
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
        	echo "Checking SALESDATA link"
        	msg1="SALESDATA link                  "
		n1=0
		if [ -L SALESDATA ] 
		then
	        	n1=$( ls SALESDATA/y* | wc -w )					# Execute commands to set n1
		fi
        	t1=$( [ -L SALESDATA ] && [ $n1 -eq 318 ]; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
        	echo ""

		echo "Checking data in SALESDATA files. This may take a minute."
		of=".q04_txt"
		$script > $of
		msg1="cars sold in 2010               "
		msg2="cars sold in July 2013          "
		msg3="Odyssey's sold in 2015          "
		msg4="cars sold by Linda Carr in 2014 "
		msg5="VIN Search                      "
        	msg6="Checking total cars in all years"
		v1=${a[$a1]}
		v2=${a[$a2]}
		v3=${a[$a3]}
		v4=${a[$a4]}

		n1=$( grep $v1 $of | wc -l )
		t1=$( [ $n1 -eq 1 ] ; echo $? )
        	check $t1 $n1 "$msg1"
		n2=$( grep $v2 $of | wc -l )
		t2=$( [ $n2 -eq 1 ] ; echo $? )
        	check $t2 $n2 "$msg2"
		n3=$( grep $v3 $of | wc -l )
		t3=$( [ $n3 -eq 1 ] ; echo $? )
        	check $t3 $n3 "$msg3"
		n4=$( grep $v4 $of | wc -l )
		t4=$( [ $n4 -eq 1 ] ; echo $? )
        	check $t4 $n4 "$msg4"

		n5=$( grep "Bennett, Michele" $of | wc -l )
		t5=$( [ $n5 -eq 1 ] ; echo $? )
        	check $t5 $n5 "$msg5"
		tot=0
		for i in 1 2 3 4 5 6 8 9 10 11 12 13 15 16 17 18 19 20 22 23 24 25 26 27 
		do
                	n=$(grep "${a[$i]}" $of | grep -v JE | wc -l)
                	tot=$((tot + n))
        	done
        	t6=$( [ $tot -eq 24 ] ; echo $? )
        	check $t6 $tot "$msg6"
        	echo ""
		rm $of
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
	echo ""
	echo "Checking SALESDATA link"
	n=0
	t=$( [ -e $script ] ; echo $? );
	msg0="SALESDATA link                  "
	check $t $n "$msg0";
	echo ""
	echo "Checking data in SALESDATA files. This may take a minute or two."
	msg1="cars sold in 2010               "
	msg2="cars sold in July 2013          "
	msg3="Odyssey's sold in 2015          "
	msg4="cars sold by Linda Carr in 2014 "
	msg5="VIN Search                      "
	msg6="Checking total cars in all years"
	check $t $n "$msg1";
	check $t $n "$msg2";
	check $t $n "$msg3";
	check $t $n "$msg4";
	check $t $n "$msg5";
	check $t $n "$msg6";
	echo ""
	echo "$script not found - INCOMPLETE SOLUTION"

fi

