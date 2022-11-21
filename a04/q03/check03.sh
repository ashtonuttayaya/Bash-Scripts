#!/bin/bash
dir=`pwd`

flag=`echo $dir|awk '{print match($0,"a04/q03")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a04/q03

fi
anum="a04"		# (a|h|e)XX
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
        where=${where/'/a04/q03'//}
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
#
#         0    1    2    3    4    5    6    7    8    9   10   11   12
array=(  52  243   76  319   39   23   62   34   38   77   40   12   52 )
sym=(  "A." "B." "C." "D." "E." "F." "G." "H." "I." "J." "K." "L." "M." )
if [ $testing -eq 0 ]
then
	file="a03.txt"
else
	file="solution03.txt"
fi 

	(
        	cd $qdir
		echo "Checking sql file contents"
		n1=0
		v1=${array[1]}
		msg1="INSERT count in agents.sql "
	        if [ -e agents.sql ] 
	        then
	                n1=$( grep -iw INSERT agents.sql | wc -l )
	        fi
		n2=0
		v2=${array[4]}
		msg2="INSERT count in dealers.sql"
	        if [ -e dealers.sql ] 
	        then
	                n2=$( grep -iw INSERT dealers.sql | wc -l )
	        fi

		n3=0
		v3=${array[7]}
		msg3="INSERT count in owners.sql "

	        if [ -e owners.sql ] 
	        then
	                n3=$( grep -iw INSERT owners.sql | wc -l )
	        fi
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
        	t2=$( [ $n2 -eq $v2 ] ; echo $? )	# Modify as needed
        	check $t2 $n2 "$msg2"
        	t3=$( [ $n3 -eq $v3 ] ; echo $? )	# Modify as needed
        	check $t3 $n3 "$msg3"
	        echo ""

	        echo "Checking database counts"
		v4=299
		n4=0
	        if [ -e $file ]
	        then
			n4=$( cat $file | wc -c )
		fi
		msg4="a03.txt                    "
		t4=$( [ $n4 -gt $v4 ] ; echo $? )
		check $t4 $n4 "$msg4"
		msg5="Part A.                    "
		msg6="Part B.                    "
		msg7="Part C.                    "
		msg8="Part D.                    "
	        na=${array[2]}
	        n5=${array[3]}
	        nb=${array[5]}
	        n6=${array[6]}
	        nc=${array[8]}
	        n7=${array[9]}
	        nd=${array[11]}
	        n8=${array[12]}
	        v5=$(( n5 - na ))
	        v6=$(( n6 - nb ))
	        v7=$(( n7 - nc ))
	        v8=$(( n8 - nd ))
	        if [ $testing -eq 1 ]
	        then
			target="solution03.txt"
		else
			target="a03.txt"
		fi
		n5=$( cat $target | grep -i "^${sym[0]}" | grep $v5 | wc -l )
		n6=$( cat $target | grep -i "^${sym[1]}" | grep $v6 | wc -l )
		n7=$( cat $target | grep -i "^${sym[2]}" | grep $v7 | wc -l )
		n8=$( cat $target | grep -i "^${sym[3]}" | grep $v8 | wc -l )
		t5=$( [ $n5 -eq 1 ] ; echo $? )
		check $t5 $n5 "$msg5"
		t6=$( [ $n6 -eq 1 ] ; echo $? )
		check $t6 $n6 "$msg6"
		t7=$( [ $n7 -eq 1 ] ; echo $? )
		check $t7 $n7 "$msg7"
		t8=$( [ $n8 -eq 1 ] ; echo $? )
		check $t8 $n8 "$msg8"
        	echo ""
	)

if [ $building -gt 0 ] 
then
	cat a03.bak > a03.txt
fi
