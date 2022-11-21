#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a06/q04")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a06/q04

fi
anum="a06"		# (a|h|e)XX
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
        where=${where/'/a06/q04'//}
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

		n1=$(ls dev_v4.* | grep -i dev_v4.sql | wc -l)
        	n2=$(ls dev_v4.* | grep -i dev_v4.txt | wc -l)

	        n3=0
#			agents owners dealers N2012 U2013 N2016 U2016
	        for i in 259 36 41 40612 30836 60632 36296
	        do
	                sn=$(grep -i "^$i$" dev_v4.txt | wc -l)
	                if [ $sn -ge 1 ]
	                then
	                        n3=$((n3+1))
	                fi
	        done

	        n4=0
	        for i in agents dealers owners 2012 2013 2016
	        do
	                sn=$(grep -i "$i" dev_v4.sql | wc -l)
	                if [ $sn -ge 1 ]
	                then
	                        n4=$((n4+1))
        	        fi
        	done
		v1=17
		v2=16
		n1=$(( 10*n1 + n3 ))
		n2=$(( 10*n2 + n4 ))
		echo "Checking dev_v4.txt and dev_v4.sql"
		msg1="dev_v4.txt                                "
		msg2="dev_v4.sql                                "  
		t1=$( [ $n1 -eq $v1 ] ; echo $? )
		t2=$( [ $n2 -eq $v2 ] ; echo $? )
		check $t1 $n1 "$msg1"
		check $t2 $n2 "$msg2"
	        echo ""

        	echo "Comparing dev_v3.sql and dev_v4.sql"
        	cat ../q03/dev_v3.sql | grep -v "2016" > .v63
        	cat dev_v4.sql | grep -v "2016" > .v64
        	n6=$(diff .v63 .v64 | wc -l)
        	rm .v63 .v64
        	n7=$(diff dev_v4.sql ../q03/dev_v3.sql | grep "^<" | wc -l )
        	n8=$(diff dev_v4.sql ../q03/dev_v3.sql | grep "^<" | grep -v 2016 |  wc -l )
        	n9=$((n7-n8))
        	if [ $n6 -eq 0 ] && [ $n7 -eq 2 ] && [ $n8 -eq 0 ]
        	then
        	        msg7="dev_v3 and dev_v4 sql files consistent    "
        	else
        	        msg7="dev_v3 and dev_v4 sql files are not consistent"
        	fi
		t7=$( [ $n6 -eq 0 ] && [ $n7 -eq 2 ] && [ $n8 -eq 0 ] ; echo $?  )
		nc=$(( n7*100 + 10*n8 + n6 ))
		check $t7 $nc "$msg7"
        	echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

