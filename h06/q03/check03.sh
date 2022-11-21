#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"h06/q03")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/h06/q03

fi
anum="h06"		# (a|h|e)XX
qnum="q03"		# qXX
rnum="08"		# text for question number
#
#
script=$qdir/q03.sh
script2=$qdir/script08.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/h06/q03'//}
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
        	echo "Check for required files (q03.sh & q03.sql)"

        	for f in q03.sh q03.sql
        	do
                	msg="                 "
			l=$(expr length "$f")		# need to create equal length strings in msg
			ml="${f:0:$l}"
			mr="${msg:$l+1}"
			msg="$ml""$mr"
			t=$( [ -e $f ] ; echo $? )
			check $t 1 "$msg"
        	done
		echo ""

		echo "Checking commands in q03.sql"
                total=0
                found=0
	        if [ -e q03.sql ]
        	then
                	for string in "show databases;" "show tables;" "describe students;" "use "
                	do
                        	n1=`cat q03.sql | grep -ic "$string"`
                        	if [ $n1 -eq 1 ]
                        	then
                                	found=$((found + 1))
                        	fi 
                        	total=$((total+1))
                	done
                
		else
			total=7
			found=0
		fi
		msg1="mysql commands  "
		t1=$( [ $total -eq $found ] ; echo $? )
                check $t1 $found "$msg1"
		echo ""
		total=0
		found=0
		if [ -e q03.sh ]
        	then
                	./q03.sh > q03check.out
                	for string in "Database" "information_schema" "Tables" "students" "Field" "pkey" "student_id" "fname" "lname" "gender" "year" "gpa" "hours"
                	do
                        	n1=`cat q03check.out | grep -ic "^$string"`
                        	if [ $n1 -eq 1 ]
                        	then
                                	found=$((found + 1))
                        	fi 
                        	total=$((total+1))
				# echo $string $found $total
                	done
			rm q03check.out
		else
			total=7
			found=0
		fi
		echo "Checking database creation"
#		echo $total $found
		msg2="data description"
		t2=$( [ $total -eq $found ] ; echo $? )
		check $t2 $found "$msg2"

		echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

