#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"h08/q03")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/h08/q03
fi
script=$qdir/q03.sh
script2=$qdir/script03.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
	where=$( echo $dir )
	where=${where/'/h08/q03'//}
	if [ -e $where/testing ]
	then
		testing=1
		cp $script2 $script
	else
		testing=0
	fi
fi
#
#	Standard checking fuctions
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
# Customize this output for the particular script or activity
#

if [ -e $script ]
then
#
# Customize these commands for the particular script or activity
#
	echo "Checking script functions"
	(
	cd $qdir
	n1=$($script texts | wc -l )
	n2=$($script stories | wc -l )
        n3=$( $script texts | grep weeping | grep "79\s*961\s*$" | wc -w )
        n4=$( $script texts | grep dennis | grep "135\s*1668\s*$" | wc -w )
        n5=$( $script stories | grep aladdin | grep "151\s*1777\s*$" | wc -c )
        n6=$( $script stories | grep slyfox | grep "168\s*1451\s*$" | wc -c )

	v1=8
	v2=6
#	v1=7
#	v2=5
	v3=3
	v4=3
	v5=21
	v6=20
#	echo "$n1 $n2 $n3 $n4 $n5 $n6"
	msg1="processed all files"
	t1=$( [ $n1 -eq $v1 ] && [ $n2 -eq $v2 ] ; echo $? ) 
	c1=$(( n1 + 100*n2 ))
	check $t1 $c1 "$msg1"

	msg2="output format      "
	c2=$(( n3 + 100*n4 ))
	t2=$( [ $n3 -eq $v4 ] && [ $n4 -eq $v3 ] ; echo $? )
	check $t2 $c2 "$msg2" 

	msg3="word count values  "
	t3=$( [ $n5 -ge $v5 ] && [ $n6 -ge $v6 ] ; echo $? )
	c3=$(( n5 + 100*n6 ))
	check $t3 $c3 "$msg3" 

	msg3="Exit on error      "
	v5=0
	v6=1
	n5=$($script missing | grep -i missing | wc -l )
	n6=$( $script | wc -l )

	t3=$( [ $n5 -ge $v5 ] && [ $n6 -ge $v6 ] ; echo $? )
	c3=$(( n5 + 100*n6 ))
	check $t3 $c3 "$msg3" 
	echo ""

	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

