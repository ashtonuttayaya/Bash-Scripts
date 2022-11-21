#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"e02/q03")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/e02/q03

fi
anum="e02"		# (a|h|e)XX
qnum="q03"		# qXX
rnum="03"		# text for question number
#
#
script=$qdir/q03.sh
script2=$qdir/script03.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/e02/q03'//}
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
NN=72904
NU=32292
NT=72904
#
# Customize this output for the particular script or activity
#
(	cd $qdir
	echo "Checking script results"
	$script 2015 > .mout 2> /dev/null
	n1=$(cat q03.sql | wc -l)	# should be greater than 4
	n2=$(grep -i "use sales" q03.sql | wc -l) 
	n3=$(grep -i "count" q03.sql | grep -i sales_2015 | wc -l)
	n4=$(grep -i "count" q03.sql | grep -i sales_2015 | grep -i where | grep -i new | wc -l)
	n5=$(grep -i "count" q03.sql | grep -i sales_2015 | grep -i where | grep -i used | wc -l)
	$script 2012 > .mout 2>/dev/null
	n6=$(grep -iw $NN .mout | wc -l)
	n7=$(grep -iw $NU .mout | wc -l)
	n8=$(grep -iw $NT .mout | wc -l)
#	echo "$n1 $n2 $n3 $n4 $n5 $n6 $n7 $n8 $n9"
	msg1="Use statement               "
	t1=$( [ $n1 -ge 4 ] && [ $n2 -eq 1 ] ; echo $? )
	n1=$(( 10*$n1 + $n2 ))
	check $t1 $n1 "$msg1"

	msg3="Select statements           "
	t3=$( [ $n3 -ge 3 ] && [ $n4 -eq 1 ] && [ $n5 -eq 1 ] && [ $n6 -eq 1 ] && [ $n7 -eq 1 ] && [ $n8 -eq 1 ] ; echo $? )
	n3=$(( $n8 + 10 * ( $n7 + 10 * ( $n6 + 10 * ( $n5 + 10 * ( $n4 + 10*$n3) ) ) ) ))
	check $t3 $n3 "$msg3"
	$script 2019 > .aout 2>/dev/null
	$script 2009 > .bout 2>/dev/null

	n9=$(cat .bout | wc -l)
	n1=$(cat .aout | wc -l)
	msg9="Command line parameter check"
	t9=$( [ $n9 -eq 1 ] && [ $n1 -eq 1 ]  ; echo $? )
	n9=$(( 10*$n9 + $n1 ))
	check $t9 $n9 "$msg9"

	$script 2014 > .mout 2> /dev/null
	n10=$(grep -i sales_2014 q03.sql | wc -l)
	v10=3
	msg10="Valid Parameter Use         "
	t10=$( [ $n10 -eq $v10 ] ; echo $? )
	check $t10 $n10 "$msg10"
	echo ""
	rm .mout .aout .bout
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

