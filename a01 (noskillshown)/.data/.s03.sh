#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a01/q03")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a01/q03

fi
anum="a01"		# (a|h|e)XX
qnum="q03"		# qXX
rnum="03"		# text for question number
#
#
script=$qdir/check03.sh
script2=$qdir/script03.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/a01/q03'//}
        if [ -e $where/testing ]
        then
                testing=1
                cp $script2 $script
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
	        jobs=$qdir/jobs.txt
	        files=$qdir/files.txt
	        all=$qdir/all.txt
	        test=$HOME/tests
	        n1=`ls $jobs $files $all 2> /dev/null | wc -w`
	        a=`cat $jobs 2>/dev/null | wc -c`
	        b=`cat $files 2>/dev/null | wc -c`
	        c=`cat $all 2>/dev/null | wc -c`
		n2=$(( a + b + c ))	
	        n3=$(( a + b - c ))
		v1=7
		v3=0
	        if [ -e $test ] 
	        then

	                n1=$(( n1+1 ))
	        fi
	        if [ -e $test/jobs.txt ] 
	        then

	                n1=$(( n1+1 ))
	        fi
	        if [ -e $test/files.txt ] 
	        then

	                n1=$(( n1+1 ))
	        fi
	        if [ -e $test/all.txt ] 
	        then

	                n1=$(( n1+1 ))
	        fi
        	echo "Looking for files"
        	msg1="txt files found in tests"
        	t1=$( [ $n1 -eq $v1 ] ; echo $? ) # Modify as needed
        	check $t1 $n1 "$msg1"
		msg3="Files copied to q03"
	        t3=$( [ $n3 -eq $v3 ] && [ $n2 -gt 0 ] ; echo $? )
		num=$(( 100*n2 + n3 ))
        	check $t3 $num "$msg3"
        	echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

