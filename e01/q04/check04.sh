#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"e01/q04")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/e01/q04

fi
anum="e01"		# (a|h|e)XX
qnum="q04"		# qXX
rnum="04"		# text for question number
#
#
script=$qdir/check04.sh
script2=$qdir/script04.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/e01/q04'//}
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
        	echo "Checking for q04.sh"
        	t1=$( [ -e q04.sh ] ; echo $? )	# Modify as needed
	      	msg1="Found q04.sh              "
		n=1
		shopt -s expand_aliases
		if [ $t1 ] && [ -e q04.sh ]
		then
			source q04.sh

		else
			msg1="Did not find q04.sh       "
			n=0
		fi
		check $t1 $n "$msg1"
        	echo ""

		echo "Checking for CROOT and EXAM1 environment variables"
		n=$( printenv CROOT | grep -E "/class$" | wc -l)
		t2=$( [ $n -eq 1 ]  ; echo $? )
		msg2="Definition of CROOT       "
		check $t2 $n "$msg2"
		msg2="Definition of EXAM1       "
		n=$( printenv EXAM1 | grep -E "/e01$" | wc -l)
		t2=$( [ $n -eq 1 ]  ; echo $? )
		check $t2 $n "$msg2"
		echo ""

		echo "Checking rfs, ims and chs aliases"
		n=$( alias | grep "alias rfs" | wc -l )
		if [ $n -gt 0 ]
		then  
			n=$( rfs t4.html | wc -l)
			t2=$( [ $n -eq 42 ]  ; echo $? )
			msg2="Definition of rfs         "
		fi
		check $t2 $n "$msg2"
		msg2="Definition of ims         "
		n=$( alias | grep "alias ims" | wc -l )
		if [ $n -gt 0 ]
		then  
			n=$( ims t4.html | wc -l)
			t2=$( [ $n -eq 5 ]  ; echo $? )
		fi
		check $t2 $n "$msg2"
		msg2="Definition of chs         "

		n=$( alias | grep "alias chs" | wc -l )

		if [ $n -gt 0 ]
		then  
			n=$( cat t3.html | chs )
			t2=$( [ $n -eq 1807 ]  ; echo $? )
		fi
		check $t2 $n "$msg2"
		echo ""
		
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

