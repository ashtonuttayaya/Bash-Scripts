#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"h08/q05")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/h08/q05
fi

script=$qdir/q05.sh
script2=$qdir/script05.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
	where=$( echo $dir )
	where=${where/'/h08/q05'//}
	if [ -e $where/testing ]
	then
		testing=1
		cp $script2 $script
	else
		testing=0
	fi
fi
#
#       Set standard functions for checking routines
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

if [ -e $script ]
then
#
# Customize these commands for the particular script or activity
#
echo "Check script performance"

(
	cd $qdir
	v1=2
	v2=11
	v3=1
	v4=1
	v5=1
	v6=1
	v7=54
	v8=5

	n1=$( $script class1.dat | grep -i "==========" | wc -l )
	n2=$( $script class1.dat | grep -w 10 | wc -l)
	msg1="basic labels             "
	t1=$( [ $n1 -eq 2 ] && [ $n2 -eq 11 ] ; echo $? )
	c1=$(( n1 + 100*n2 ))
	check $t1 $c1 "$msg1"

        n3=$( $script class2.dat | grep "Anderson, Allen" | grep -w 84 | wc -l )
        n4=$( $script class1.dat | grep "Simpson, Brooke" | grep -w 93 | wc -l)
	msg2="calculated totals        "
	t2=$( [ $n3 -eq 1 ] && [ $n4 -eq 1 ] ; echo $? )
	c2=$(( n3 + 100*n4 ))
	check $t2 $c2 "$msg2"

        n5=$( $script class2.dat | grep "Anderson, Allen" | grep -w "8.40" | wc -l )
        n6=$( $script class1.dat | grep "Simpson, Brooke" | grep -w "9.30" | wc -l)
	msg3="calculated averages      "
	t3=$( [ $n5 -eq 1 ] && [ $n6 -eq 1 ] ; echo $? )
	c3=$(( n5 + 100*n6 ))
	check $t3 $c3 "$msg3"

	n7=$( $script class2.dat | grep -ivE "=|Name" | wc -l )
	t7=$( [ $n7 -eq 11 ] ; echo $? )
	msg7="all students processed   "
	check $t7 $n7 "$msg7"

	n7=$($script class2.dat | grep "Frank" | wc -c)
	n8=$($script class2.dat | grep "Sarah" | wc -c)
	msg4=""
	if [ $n7 -eq $n8 ]
	then
		msg4="fixed length lines       "
	else
		msg4="lines are not fixed length"
	fi
	t4=$( [ $n7 -eq $n8 ] ; echo $? )
	c4=$(( n7 + 100*n8 ))
	check $t4 $c4 "$msg4"

)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

echo ""
