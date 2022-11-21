#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"h09/q05")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/h09/q05

fi
anum="h09"		# (a|h|e)XX
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
        where=${where/'/h09/q05'//}
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
        	echo "Checking output file"
		n1=0
	        if [ -e cmovies.txt ]
		then
			msg1="cmovies.txt exists         "
			n1=1
		else
			msg1="cmovies.txt does not exist - can't continue"
			m1=0
		fi
        	t1=$( [ -e cmovies.txt ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
		if [ ! -e cmovies.txt ]
		then
			exit
		fi
        	echo ""

        	echo "Checking for any remaining tags or blank lines"
        	msg2="Count of remaining tags    "
		n2=$(cat cmovies.txt | grep -E "MOVIES|MOVIE|TITLE|RANK|YEAR|MEN|WOMEN|TOTAL"| wc -c)
        	v2=0					# Set expected value for test
        	t2=$( [ $n2 -eq $v2 ]; echo $? ) 	# Modify as needed
        	check $t2 $n2 "$msg2"
        	msg2="Number of lines            "
		n2=$(cat cmovies.txt | wc -l)
        	v2=252					# Set expected value for test
        	t2=$( [ $n2 -eq $v2 ]; echo $? ) 	# Modify as needed
        	check $t2 $n2 "$msg2"
        	msg2="Comparison with movies.txt "
		n2=$(diff cmovies.txt .movies.txt | grep -iE "Marshall" | wc -l)
        	v2=1					# Set expected value for test
        	t2=$( [ $n2 -eq $v2 ]; echo $? ) 	# Modify as needed
        	check $t2 $n2 "$msg2"
        	echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

