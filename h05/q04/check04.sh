#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"h05/q04")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/h05/q04

fi
anum="h05"		# (a|h|e)XX
qnum="q04"		# qXX
rnum="04"		# text for question number
#
#
script=$qdir/q04.sh
script2=$qdir/script04.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/h05/q04'//}
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
	        file="records.tmp"
        	echo "Checking script output"
        	msg1="number of output records"
        	msg2="data values             "
	        $script list.dat > $file
        	v1=84				# Set expected value for test 1
        	n1=$( grep -i PKEY $file | wc -l)
        	t1=$( [ $n1 -eq $v1 ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"

		fnames=( "MATTHEW" "MATTHEW" "JULIAN" "JULIAN" "JOHN" "MADISON" )
		lnames=( "ANDERSON" "ANDERSON" "BURNS" "BURNS" "SMITH" "WILLIAMS" )
		types=( "HW" "QU" "HW" "EX" "HW" "HW" )
		scores=(4 10 5 39 4 3 )
		values=( 6 2 3 1 0 4 )
		n=( -1 -2 -3 -4 -5 -6 )
		for i in {0..5}
		do
			fn=${fnames[$i]}
			ln=${lnames[$i]}
			ty=${types[$i]}
			sc=${scores[$i]}
	        	n[$i]=$(grep -i "FNAME=$fn" $file | grep -i "LNAME=$ln" | grep -i "TYPE=$ty" | grep -i "SCORE=$sc" | wc -l)
#			echo "testing = i, fname, lname, type, score, nvalue = ($i $fn $ln $ty $sc ${n[$i]})"
		done
		t2=$( [ ${n[0]} -eq ${values[0]} ] && [ ${n[1]} -eq ${values[1]} ] && [ ${n[2]} -eq ${values[2]} ]  && 
		      [ ${n[3]} -eq ${values[3]} ] && [ ${n[4]} -eq ${values[4]} ] && [ ${n[5]} -eq ${values[5]} ] ; echo $? )
		c2=0
		for i in {0..5}
		do
			c2=$(( ${n[i]} + 100*c2 ))
		done
#		echo "testing c2 = $c2"
		check $t2 $c2 "$msg2"
	        rm $file
        	echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

