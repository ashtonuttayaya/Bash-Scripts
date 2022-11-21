#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a05/q02")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a05/q02

fi
anum="a05"		# (a|h|e)XX
qnum="q02"		# qXX
rnum="02"		# text for question number
#
#
script=$qdir/check02.sh
script2=$qdir/script02.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/a05/q02'//}
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
	code="chx""q02-""${csym[$cindex]}"
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
function check_count {
	years=(2010 2011 2012 2013 2014 2015)
	counts=(66144 69471 72904 76544 79664 89492)
	found=0
	for i in {0..5}
	do
		if [ "$2" == "${counts[$i]}" ]
		then
			found=1
		fi
	done
	echo $found
	return
}

if [ -e $script ]
then
	(

        	cd $qdir
cat > .input << SQL
use sales;
show tables;
select count(*) as "count 2010" from sales_2010;
select count(*) as "count 2011" from sales_2011;
select count(*) as "count 2012" from sales_2012;
select count(*) as "count 2013" from sales_2013;
select count(*) as "count 2014" from sales_2014;
select count(*) as "count 2015" from sales_2015;
SQL

#
#	Check for the environment variables MYSQL_USER, MYSQL_PASS, MYSQL_DATA and make sure they are set
#
		q01dir="${qdir/q02/q01}"		# replace q02 with q01

		echo "Checking your MYSQL_USER, MYSQL_PASS and MYSQL_DATA environment variables"
		msg0="q01/env_mysql check       "
		n0=0
		if [ -e $q01dir/env_mysql ]
		then
			n0=$( ls $q01dir/env_mysql | grep -i env_mysql | wc -l )
		fi
		t0=$( [ -e $q01dir/env_mysql ] ; echo $? )
		check $t0 $n0 "$msg0"
		n1=0
		n2=0
		n3=0
		nc=10
		v1=1
		v2=6
		v3=6
		msg1="sales database            "
		msg2="yearly sales tables       "
		msg3="yearly sales count values "
		if [ -e $q01dir/env_mysql ] 
		then 
			source $q01dir/env_mysql
			mysql -u $MYSQL_USER -p$MYSQL_PASS < .input > .results  2> /dev/null

		fi
		total=0
		if [ -e .results ]
		then
			n1=$(grep -i Tables_in_sales .results | wc -l)
			n2=$(grep -iE 'sales_2010|sales_2011|sales_2012|sales_2013|sales_2014|sales_2015' .results | wc -l)
			for i in 2010 2011 2012 2013 2014 2015 
			do
				n=$(grep -i -A1 "count $i" .results | grep -iv count) 
				n3=$(check_count $i $n)
				nc=$(( n + 10*nc ))
				total=$((total+n3))
			done
		fi
		n3=$total
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
        	t2=$( [ $n2 -eq $v2 ] ; echo $? )	# Modify as needed
        	check $t2 $n2 "$msg2"
        	t3=$( [ $n3 -eq $v3 ] ; echo $? )	# Modify as needed
        	check $t3 $nc "$msg3"

		echo ""
		nrun=$( ps -aef | grep -i mysql | grep -v root | grep -i xxx | wc -l )
		if [ $nrun -gt 0 ]
		then
			echo "NOTE:  Your database is still being updated"
			echo "       check02.sh will not give all OK's until"
			echo "       all of your database updates finish"
			echo ""
		fi

		if [ -e .input ]
		then
			rm .input
		fi
		if [ -e .results ]
		then
			rm .results
		fi

	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

