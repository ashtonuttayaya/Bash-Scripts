#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"h03/q02")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/h03/q02

fi
anum="h03"		# (a|h|e)XX
qnum="q02"		# qXX
rnum="02"		# text for question number
#
#
script=$qdir/q02.sh
script2=$qdir/script02.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/h03/q02'//}
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
#
#	Start by removing any definitions
#
		unalias accounts 2> /dev/null
fn_exists() {
        [ `type -t $1`"" == 'function' ]
}

if ! fn_exists extract; then
        unset -f extract
fi

if ! fn_exists cleanup; then
        unset -f cleanup
fi

if [ ! -z "$Q2" ]
then
        unset Q2
fi

if [ ! -z "$WEB" ]
then
        unset WEB
fi

		source $script

        	echo "Checking alias and environment variables"

		n1=$(printenv | grep "^Q2=" | grep $USER | grep class/h03/q02 | wc -l)
		n2=$(printenv | grep "^WEB=" | grep /home/$USER/public_html | wc -l)
		n3=$(alias accounts | grep "ls /home" | wc -l)
		v1=1
		v2=1
		v3=1
        	msg1="Environment variable Q2    "
		msg2="Environment variable WEB   "
		msg3="alias accounts             "
		
        	t1=$( [ $n1 -eq $v1 ]; echo $? ) # Modify as needed
        	check $t1 $n1 "$msg1"
        	t2=$( [ $n2 -eq $v2 ]; echo $? ) # Modify as needed
        	check $t2 $n2 "$msg2"
        	t3=$( [ $n3 -eq $v3 ]; echo $? ) # Modify as needed
        	check $t3 $n3 "$msg3"
		echo ""
#
#	Begin checking functions (definitions and results)
#

		echo "Checking functions"

		fn_exists() {
			local $val
        		val=$( type -t $1 | grep -i "function" | wc -l)
			echo $val
		}

		v4=1
		v5=23
		v6=1
		v7=1
		msg4="function extract definition"
		msg5="extract results            "
		msg6="function cleanup definition"
		msg7="cleanup results            "
		n4=$( fn_exists extract )
		t4=$( [ $n4 -eq $v4 ] ; echo $? )
		check $t4 $n4 "$msg4"
		if [ $n4 -eq $v4 ]
		then		        
	        	extract 4
		fi
		n5=$( cat t4.txt | wc -l)
		t5=$( [ $n5 -eq $v5 ] ; echo $? )
		check $t5 $n5 "$msg5"

		n6=$( fn_exists cleanup )
		t6=$( [ $n6 -eq $v6 ] ; echo $? )
		check $t6 $n6 "$msg6"

		if [ $n6 -eq $v6 ]
		then
		        cleanup 4
		fi
		if [ ! -e t4.txt ]
		then
			n7=1		# cleanup should have removed the file
		else
			n7=0		# oh, we didn't remove it properly
		fi
		t7=$( [ $n7 -eq $v7 ] ; echo $? )
		check $t7 $n7 "$msg7"
		echo ""

	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

