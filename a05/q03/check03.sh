#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a05/q03")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a05/q03

fi
anum="a05"		# (a|h|e)XX
qnum="q03"		# qXX
rnum="03"		# text for question number
#
#
script=$qdir/check03.sh
script2=$qdir/script03.sh
b=7365
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/a05/q03'//}
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
building=0
if [ $# -gt 0 ] 
then
        building=1
        cp solution03.txt a03.txt
fi


#
#	Set standard functions for checking routines
#
cindex=0
csym=( A B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI AJ AK AL AM AN AO AP AQ AR AS AT AU AV AW AX AY AZ )
a=(73509 13864 26668 7496 13131)

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

        	echo "Checking q03.sql"
        	msg0="q03.txt                         "
		msg0="file q03.sql                    "
        	msg4="VIN select                      "
		msg1="Cars in July 2013               "
		msg2="Odyssey in 2015                 "
		msg3="Cars sold by Linda Carr         "
		msg5="Profit data                     "
		t0=$( [ -e q03.sql ] ; echo $? )
		n0=0
		n1=0
		n2=0
		n3=0
		n4=0
		n5=0

		if [ -e q03.sql ]
		then
			n0=1
	                n1=$( grep -i select q03.sql | grep -i sales_2013 | wc -l )
	                n2=$( grep -i select q03.sql | grep -i sales_2015 | wc -l )
	                n3=$( grep -i select q03.sql | grep -i sales_2014 | wc -l )
	                n4=$( grep -i select q03.sql | grep -i vin | wc -l )
	                n5=$( grep -i price_sold q03.sql | grep -i dealer_cost | wc -l )
		fi
                t1=$( [ $n1 -gt 0 ]; echo $? )
                t2=$( [ $n2 -gt 0 ] ; echo $? )
                t3=$( [ $n3 -gt 0 ] ; echo $? )
                t4=$( [ $n4 -gt 0 ] ; echo $? )
                t5=$( [ $n5 -gt 0 ] ; echo $? )
        	check $t0 $n0 "$msg0"
        	check $t1 $n1 "$msg1"
        	check $t2 $n2 "$msg2"
        	check $t3 $n3 "$msg3"
        	check $t4 $n4 "$msg4"
        	check $t5 $n5 "$msg5"
        	echo ""

        	echo "Checking q03.txt"
        	msg0="q03.txt                         "
		msg1="Cars in 2010                    "
		msg2="Cars in July 2013               "
		msg3="Odysseys in 2015                "
		msg4="Cars sold by Linda Carr         "
		msg5="Profit for vin=JE142FU145525XBX8"
		n0=0
		n1=0
		n2=0
		n3=0
		n4=0
		n5=0
		t0=$( [ -e q03.txt ] ; echo $? )
		if [ -e q03.txt ]
		then
			n0=1
                	let t=${a[0]}-$b
                	n1=$( grep -iw $t q03.txt | wc -l)
                	let t=${a[1]}-$b
                	n2=$( grep -iw $t q03.txt | wc -l)
                	let t=${a[2]}-$b
                	n3=$( grep -iw $t q03.txt | wc -l)
                	let t=${a[3]}-$b
                	n4=$( grep -iw $t q03.txt | wc -l)
                	let t=${a[4]}-$b
                	n5=$( grep -iw $t q03.txt | wc -l)
		fi
		t1=$( [ $n1 -eq 1 ] ; echo $? )
		t2=$( [ $n2 -eq 1 ] ; echo $? )
		t3=$( [ $n3 -eq 1 ] ; echo $? )
		t4=$( [ $n4 -eq 1 ] ; echo $? )
		t5=$( [ $n5 -eq 1 ] ; echo $? )
        	check $t0 $n0 "$msg0"
        	check $t1 $n1 "$msg1"
        	check $t2 $n2 "$msg2"
        	check $t3 $n3 "$msg3"
        	check $t4 $n4 "$msg4"
        	check $t5 $n5 "$msg5"
        	echo ""

		if [ $building -gt 0 ] 
		then
        		cat a03.bak > a03.txt
		fi
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

