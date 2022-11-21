#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a02/q02")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a02/q02

fi
anum="a02"		# (a|h|e)XX
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
        where=${where/'/a02/q02'//}
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
        	echo "Looking for bin directory"
        	msg1="bin directory         "
        	msg2="decode.sh             "
        	msg3="results.txt content   "
		msg6="decode.sh run from bin"
        	v1=1				  # Set expected value for test 1
#       Execute commands to set n1
        	if [ -e ~/bin ] && [ -d ~/bin ] 
		then
			n1=1
		else
			n1=0
		fi
        	t1=$( [ $n1 -eq $v1 ] ; echo $? ) # Modify as needed
        	check $t1 $n1 "$msg1"

        	v2=1
        	if [ -e ~/bin/decode.sh ] 
		then
			n2=1
		else
			n2=0
		fi
        	t2=$( [ $n2 -eq $v2 ] ; echo $? ) # Modify as needed
        	check $t2 $n2 "$msg2"
        	echo ""

		echo "Checking results.txt"
		v6=1
		if [ -e results.txt ]
		then
			n6=1
		else
			n6=0
		fi
        	t6=$( [ $n6 -eq $v6 ] ; echo $? ) # Modify as needed
        	check $t6 $n6 "$msg6"

        	v3=1
		v4=63
		v5=4
        	if [ -e results.txt ] 
		then
			n3=$( head -5 results.txt | grep $HOME/bin | wc -l)
			n4=$( cat results.txt | wc -l)
			n5=$( grep -iow Florida results.txt | wc -l)
		else
			n3=0
			n4=0
			n5=0
		fi
		c3=$(( n5+ 100*(n4 + 100*n3) ))
        	t3=$( [ $n3 -eq $v3 ] && [ $n4 -ge $v4 ] && [ $n5 -eq $v5 ] ; echo $? ) # Modify as needed
        	check $t3 $c3 "$msg3"
        	echo ""

	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

