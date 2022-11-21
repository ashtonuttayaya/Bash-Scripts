#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a01/q01")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a01/q01

fi
anum="a01"		# (a|h|e)XX
qnum="q01"		# qXX
rnum="01"		# text for question number
#
#
script=$qdir/check01.sh
script2=$qdir/script01.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/a01/q01'//}
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
	code="chx""q01-""${csym[$cindex]}"
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
        	echo "Checking user accounts"
        	msg1="admin accounts created"
        	v1=3				  # Set expected value for test 1
        	n1=$( grep -iE ":100[0-9]:" /etc/group | grep -iE "admin|administrator" | wc -l )
        	t1=$( [ $n1 -ge $v1 ] ; echo $? ) # Modify as needed
        	check $t1 $n1 "$msg1"

        	msg2="user accounts created"
        	v2=1				  # Set expected value for test 1
        	n2=$( grep -iE ":100[0-9]:" /etc/group | grep -ivE "admin|administrator" | wc -l )
        	t2=$( [ $n2 -ge $v2 ] ; echo $? ) # Modify as needed
        	check $t2 $n2 "$msg2"
        	echo ""

		echo "Checking directory structure"
        	msg3="class directory created"
		v3=1
		if [ -e ~/class ]
		then
			n3=1
		else
			n3=0
		fi
        	t3=$( [ $n3 -eq $v3 ] ; echo $? ) # Modify as needed
        	check $t3 $n3 "$msg3"

        	msg4="a01 .. a08 created and a01.tar.gz copied"
		v4=8
		if [ -e $qdir ]
		then
	        	n4=$( ls -d $qdir/../../a0[1-8] | wc -w )
		else
			n4=0
		fi
		t4=$( [ -e $qdir/../../a01.tar.gz ] && [ $n4 -eq $v4 ] ; echo $? )
        	check $t4 $n4 "$msg4"

        	msg5="a01 extracted"
		v5=3
		if [ -e $qdir ]
		then
	        	n5=$( ls -d $qdir/../q0[1-3] | wc -w )
		else
			n5=0
		fi
  		t5=$( [ -e $qdir/../a01config ] && [ $n5 -eq $v5 ] ; echo $? )
	      	check $t5 $n5 "$msg5"
        	echo ""

	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

