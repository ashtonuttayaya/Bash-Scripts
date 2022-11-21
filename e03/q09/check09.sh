#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"e03/q09")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/e03/q09

fi
anum="e03"		# (a|h|e)XX
qnum="q09"		# qXX
rnum="09"		# text for question number
#
#
script=$qdir/q09.sh
script2=$qdir/script09.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/e03/q09'//}
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
	code="chx""q09-""${csym[$cindex]}"
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
        	of=".test.txt"
        	$script > $of
        	n1=$(grep -iw use $of | wc -l) 
        	n2=$(grep -iw create $of | wc -l)
        	n3=$(grep -iw insert $of | wc -l)
        	n4=$(grep -i 159.89 $of | grep -v "COST=" | wc -l)
        	echo "Checking SQL header information"
        	msg1="Use statement       "
        	v1=1
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )
        	check $t1 $n1 "$msg1"
		msg2="Create statement    "
		v2=1
        	t2=$( [ $n2 -eq $v2 ] ; echo $? )
        	check $t2 $n2 "$msg2"
        	echo ""

        	echo "Checking SQL for insert statements"
        	msg3="Insert statements   "
        	msg4="Inserted values     "
        	v3=19
        	v4=1
        	t3=$( [ $n3 -eq $v3 ]; echo $? ) 	# Modify as needed
        	check $t3 $n3 "$msg3"
        	t4=$( [ $n4 -eq $v4 ]; echo $? ) 	# Modify as needed
        	check $t4 $n4 "$msg4"
        	echo ""
	        rm $of

	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

