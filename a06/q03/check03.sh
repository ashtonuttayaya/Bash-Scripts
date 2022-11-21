#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a06/q03")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a06/q03

fi
anum="a06"		# (a|h|e)XX
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
        where=${where/'/a06/q03'//}
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
	(
        	cd $qdir
		echo "checking dev_v3.txt and dev_v3.sql"
        	msg1="dev_v3.txt                           "
        	msg2="dev_v3.sql                           "
        	v1=1					# Set expected value for test 1
        	n1=1					# Execute commands to set n1
        	t1=$( [ -e dev_v3.txt ] ; echo $? )	# Modify as needed
		if [ ! -e dev_v3.txt ]
		then
			n1=0
		fi

        	v2=1					# Set expected value for test 1
        	n2=1					# Execute commands to set n1
        	t2=$( [ -e dev_v3.sql ] ; echo $? )	# Modify as needed
		if [ ! -e dev_v3.sql ]
		then
			n2=0
		fi

		n3=0
		v3=5
        	for i in 259 36 41 243 34 39 40612 30836
        	do
                	sn=$(grep "^$i$" dev_v3.txt | wc -l)
                	if [ $sn -ge 1 ]
                	then
                        	n3=$((n3+1))
                	fi
        	done

    	    	n4=0
		v4=5
        	for i in agents dealers owners 2011 2013
        	do
                	sn=$(grep "$i" dev_v3.sql | wc -l)
                	if [ $sn -ge 1 ]
                	then
	                        n4=$((n4+1))
                	fi
        	done
		v1=15
		v2=15
		n1=$(( n3+10*n1 ))
		n2=$(( n4+10*n2 ))
		t1=$( [ $n1 -eq $v1 ] ; echo $? )
		t2=$( [ $n2 -eq $v2 ] ; echo $? )
        	check $t1 $n1 "$msg1"
        	check $t2 $n2 "$msg2"
	        echo " "

		echo "Comparing sales_v1.txt and dev_v3.txt"

		n5=$(diff ../q01/sales_v1.txt dev_v3.txt | wc -l)
		t5=$( [ $n5 -eq 0 ] || [ $n5 -eq 12 ] ; echo $? )
	        if [ $n5 -eq 0 ]
	        then
	                msg5="sales and dev output as expected     "
	        else
	                msg5="sales and dev output not as expected "
	        fi
		check $t5 $n5 "$msg5"
	        echo ""

        	echo "Comparing sales_v1.sql and dev_v3.sql"
        	cat ../q01/sales_v1.sql | grep -v "use sales" > .v61
        	cat dev_v3.sql | grep -v "use dev" > .v63 
        	n6=$(diff .v61 .v63 | wc -l)
#        	rm .v61 .v63
        	n7=$(diff dev_v3.sql ../q01/sales_v1.sql | wc -l )
        	n8=$(diff dev_v3.sql ../q01/sales_v1.sql | grep -v use |  wc -l )
        	n9=$((n7-n8))
        	msg6="sales and dev sql files consistent   "
	       	t6=$( [ $n6 -eq 0 ] && [ $n9 -gt 0 ] && [ $n8 -eq 2 ] ; echo $? )
		vc=200
		nc=$(( n8*100 + n6*10 + n9 ));
        	if [ $n6 -eq 0 ] && [ $n9 -gt 0 ] && [ $n8 -eq 2 ]
        	then
        	        msg6="sales and dev sql files consistent   "
        	else
        	        msg6="sales and dev sql files not consistent"
        	fi
		check $t6 $nc "$msg6"
        	echo ""

	        echo "Checking for the backup files"
		msg7="bck_sales_v3.sql.gz                  "
		msg8="bck_dev_v3.sql.gz                    "
	        if [ -e ~/backup/bck_sales_v3.sql.gz ]
        	then
                	sales=($(ls -la ~/backup/bck_sales_v3.sql.gz))
                	if [ ${sales[4]} -gt 9250000 ]
                	then
                        	n7=1
                	else
				n7=${sales[4]}
                	fi
        	else
                	n7=0
        	fi
		t7=$( [ $n7 -eq 1 ] ; echo $? )
		check $t7 $n7 "$msg7"

	        if [ -e ~/backup/bck_dev_v3.sql.gz ]
        	then
                	dev=($(ls -la ~/backup/bck_dev_v3.sql.gz))
                	if [ ${dev[4]} -gt 9250000 ]
                	then
                        	n8=1
                	else
				n8=${dev[4]}
                	fi
        	else
                	n8=0
        	fi
		t8=$( [ $n8 -eq 1 ] ; echo $? )
		check $t8 $n8 "$msg8"
        	echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

