#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"e01/q02")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/e01/q02

fi
anum="e01"		# (a|h|e)XX
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
        where=${where/'/e01/q02'//}
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
        	echo "Checking directory structure"
        	msg1="Checking directory stories      "
		n1=$( [ -d stories ]; echo $? )
		n2=$( [ -d stories/happy ]; echo $? )
		n3=$( [ -d stories/unhappy ]; echo $? )
		n4=$( [ ! -e files ]; echo $? )
		n5=$( [ -d stories/ok ]; echo $?)
		nt=$(( n5 + 10*( n4 + 10*( n3+10*(n2+10*n1))) ))
        	t1=$( [ -d stories ] && [ -d stories/happy ] && [ -d stories/unhappy ] && [ -d stories/ok ] && [ ! -e files ] ; echo $? )	# Modify as needed
        	check $t1 $nt "$msg1"
        	echo ""

        	echo "Checking file locations"
        	msg5="Final file location check       "
        	v5=1	
        	n5=0
		if [ -e stories/happy/fun.txt ] 
		then 
			n5=$( cat stories/happy/fun.txt | wc -c )
			if [ $n5 -eq 449 ]
			then
				n5=1
			fi
		fi
        	v6=1	
        	n6=0
		if [ -e stories/happy/happy.txt ] 
		then 
			n6=$( cat stories/happy/happy.txt | wc -c )
			if [ $n6 -eq 363 ]
			then
				n6=1
			fi
		fi
        	v7=1	
        	n7=0
		if [ -e stories/unhappy/lonely.txt ] 
		then 
			n7=$( cat stories/unhappy/lonely.txt | wc -c )
			if [ $n7 -eq 235 ]
			then
				n7=1
			fi
		fi
        	v8=1	
        	n8=0
		if [ -e stories/unhappy/sad.txt ] 
		then 
			n8=$( cat stories/unhappy/sad.txt | wc -c )
			if [ $n8 -eq 262 ]
			then
				n8=1
			fi
		fi
        	v4=1	
        	n4=0
		if [ -e stories/ok/soso.txt ] 
		then 
			n4=$( cat stories/ok/soso.txt | wc -c )
			if [ $n4 -eq 235 ]
			then
				n4=1
			fi
		fi
        	t5=$( [ $n5 -eq $v5 ] && [ $n6 -eq $v6 ] && [ $n7 -eq $v7 ] && [ $n8 -eq $v8 ] && [ $n4 -eq $v4 ] ; echo $? ) 	# Modify as needed
		nt=$(( n4 + 10*(n8 + 10*(n7+10*(n6+10*n5))) ))
        	check $t5 $nt "$msg5"
		msg9="Directory files has been removed"
		v9=0
		n9=1
		if [ ! -e files ]
		then
			n9=0
		fi
		t9=$( [ $n9 -eq $v9 ]; echo $? )
		check $t9 $n9 "$msg9"
        	echo ""

	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

