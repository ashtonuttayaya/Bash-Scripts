#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a06/q06")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a06/q06

fi
anum="a06"		# (a|h|e)XX
qnum="q06"		# qXX
rnum="06"		# text for question number
#
#
script=$qdir/check06.sh
script2=$qdir/script06.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/a06/q06'//}
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
	code="chx""q06-""${csym[$cindex]}"
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
		echo "Checking sales database backup file"

        	msg1="sales_v6.sql.gz"

        	if [ -e ~/backup/sales_v6.sql.gz ]
        	then
        	        sales=($(ls -la ~/backup/sales_v6.sql.gz))
        	        if [ ${sales[4]} -gt 10000000 ]
        	        then
        	                msg1="sales_v6.sql.gz"
        	        else
        	                msg1="sales_v6.sql.gz too small ${sales[4]}"

        	        fi
        	else
			sales=(0 0 0 0 )
        	        msg1="sales_v6.sql.gz not found"
        	fi
		n1=${sales[4]}
		t1=$( [ -e ~/backup/sales_v6.sql.gz ] && [ ${sales[4]} -gt 10000000 ] ; echo $? )
        	check $t1 $n1 "$msg1"
        	echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

