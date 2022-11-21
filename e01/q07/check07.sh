#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"e01/q07")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/e01/q07

fi
anum="e01"		# (a|h|e)XX
qnum="q07"		# qXX
rnum="07"		# text for question number
#
#
script=$qdir/q07.sh
script2=$qdir/script07.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/e01/q07'//}
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
	code="chx""q07-""${csym[$cindex]}"
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
        	msg1="q07.sh                               "
		msg2="q07.sh output                        "
        	msg4="First output line displays filenames "
        	msg3="Correct character counts and files   "
 
		n0=$( ls -l $script | grep -i "x" | wc -l )
        	echo "Checking q07.sh and its output"
		n1=$( $script s1.txt s2.txt | grep s1.txt | wc -l )
        	t1=$( [ $n0 -gt 0 ] && [ $n1 -eq 2 ] ; echo $? )	# Modify as needed
		n=$(( 100 + 10*n1 + n2 ))
        	check $t1 $n "$msg1"

		n2=$( $script a07.bak s1.txt | wc -l )
        	t2=$( [ $n2 -eq 3 ]; echo $? ) 	# Modify as needed
        	check $t2 $n2 "$msg2"

		n4=$( $script a07.bak a07.txt | head -n 1 | grep -i "a07.bak" | wc -l )
        	t4=$( [ $n4 -eq 1 ]; echo $? ) 	# Modify as needed
        	check $t4 $n4 "$msg4"

		n3=$( $script a07.bak s1.txt | tail -n 2 | grep -i "s1.txt" | wc -l )
		n4=$( $script a07.bak s1.txt | head -n 2 | grep -i "a07.bak" | wc -l )
        	t3=$( [ $n3 -eq 1 ] && [ $n4 -eq 2 ]; echo $? ) 	# Modify as needed
		nt=$(( n3 + 10*n4 ))
        	check $t3 $nt "$msg3"

        	echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

