#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a05/q01")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a05/q01

fi
anum="a05"		# (a|h|e)XX
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
        where=${where/'/a05/q01'//}
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
		v1=1		# looking for env_mysql
		v2=1		# MYSQL_DATA assigned to existing SALESDATA
		v3=1		# MYSQL_PASS assigned
		v4=1		# MYSQL_USER assigned to salesadmin
		v5=1
        	msg1="env_mysql found                  "
        	msg2="MYSQL_DATA defined               "
        	msg3="MYSQL_PASS set                   "
        	msg4="MYSQL_USER (salesadmin) set      "
        	msg5="SALESDATA found                  "
		n1=0
		n2=0
		n3=0
		n4=0
		n5=0
		if [ -e env_mysql ]
		then
			n1=1
			source env_mysql
			n2=$(cat env_mysql | grep -iE "export\s{,5}MYSQL_DATA=" | grep -i "a05/q01/SALESDATA" | wc -l)
                	n3=$(cat env_mysql | grep -iE "export\s{,5}MYSQL_PASS=" | wc -l)
                	n4=$(cat env_mysql | grep -iE "export\s{,5}MYSQL_USER=" | grep -i salesadmin | wc -l)
			if [ -e $MYSQL_DATA ] && [ $n2 -eq 1 ]
                	then
				n5=1
			fi
		fi
        	echo "Checking environment definitions and SALESDATA"
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )	# Modify as needed
        	t2=$( [ $n2 -eq $v2 ] ; echo $? )	# Modify as needed
        	t3=$( [ $n3 -eq $v3 ] ; echo $? )	# Modify as needed
        	t4=$( [ $n4 -eq $v4 ] ; echo $? )	# Modify as needed
        	t5=$( [ $n5 -eq $v5 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
        	check $t2 $n2 "$msg2"
        	check $t3 $n3 "$msg3"
        	check $t4 $n4 "$msg4"
        	check $t5 $n5 "$msg5"
        	echo ""

        	echo "Checking sql files"
		for y in 2010 2011 2012 2013 2014 2015
	        do
			n0=0;
	        	t=$( [ -e s$y ] && [ -d s$y ]; echo $? ) 	# Modify as needed
			sdir="s""$y"
			if [ -e s$y ] && [ -d s$y ] 
			then
				n0=1
			fi
			msg0="$sdir directory found            "
			msg1="$sdir sql file found             "  
        		check $t $n0 "$msg0"
			n1=0;
			n2=0;
			if [ -e $sdir ] 
			then
				n1=$( ls $sdir | grep -i sql | wc -l )
				if [ -e $sdir/sales$y.sql ] 
				then
					n2=$( cat $sdir/sales$y.sql | grep -i source | wc -l )
				fi
			fi
			t1=$( [ $n1 -eq 53 ] && [ $n2 -eq 52 ] ; echo $? ) 
			nc=$(( n2 + 100*n1 ))
			check $t1 $nc "$msg1"
		done
        	echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

