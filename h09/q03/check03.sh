#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"h09/q03")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/h09/q03

fi
anum="h09"		# (a|h|e)XX
qnum="q03"		# qXX
rnum="03"		# text for question number
#
#
script=$qdir/q03.sh
script2=$qdir/script03.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/h09/q03'//}
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
	code="chx""q03-""${csym[$cindex]}"
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
        	echo "Checking report generation"
		$script stories
		$script texts
		ns=$(cat stories.rpt | wc -l )
		nt=$(cat texts.rpt | wc -l )
        	msg1="Reports created and right length "
        	v1=2					# Set expected value for test 1
		v0=4
        	n1=$(( $nt - $ns ))			# Execute commands to set n1
        	t1=$( [ $n1 -eq $v1 ] && [ $ns -ge $v0 ]; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
        	msg1="Report lines are fixed length    "
        	v1=$(cat stories.rpt | grep 11918 | wc -c) # Set expected value for test 1
        	n1=$(cat texts.rpt | grep 12.35 | wc -c) # Set expected value for test 1
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
        	msg1="Reports contain correct values   "
        	v1=1	# 12.35					# Set expected value for test 1
		v0=1 	# 11918
        	n0=$( cat stories.rpt | grep -i 11918 | wc -l )		# Execute commands to set n1
        	n1=$( cat texts.rpt | grep -i "12.35" | wc -l )		# Execute commands to set n1
        	t1=$( [ $n1 -eq $v1 ] && [ $ns -ge $v0 ]; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
        	echo ""

        	echo "Checking error processing"
        	msg2="Invalid or missing directory     "
        	v2=0					# Set expected value for test 2
		n2=0
		n2=$($script nothere | grep -i "wds/ln" | wc -l )
		if [ -e nothere.rpt ]
		then
			n2=$(($n2+1))			# Execute command to set n2
		fi
        	t2=$( [ $n2 -eq $v2 ]; echo $? ) 	# Modify as needed
        	check $t2 $n2 "$msg2"
        	echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

