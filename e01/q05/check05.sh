#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"e01/q05")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/e01/q05

fi
anum="e01"		# (a|h|e)XX
qnum="q05"		# qXX
rnum="05"		# text for question number
#
#
script=$qdir/check05.sh
script2=$qdir/script05.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/e01/q05'//}
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
	code="chx""q05-""${csym[$cindex]}"
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
        	echo "Checking for required files hrefs.txt and pics.txt"
        	msg1="hrefs.txt and pics.txt found             "
        	n1=2
        	t1=$( [ -e hrefs.txt ] && [ -e pics.txt ] ; echo $? )	# Modify as needed
		if [ ! -e hrefs.txt ] 
		then
	        	msg1="hrefs.txt and/or pics.txt not found      "
			n1=$(( n1-1 ))
		fi 
		if [ ! -e pics.txt ] 
		then
	        	msg1="hrefs.txt and/or pics.txt not found      "
			n1=$(( n1-1 ))
		fi 
        	check $t1 $n1 "$msg1"
	       	echo ""

        	echo "Examining file content of hrefs.txt and pics.txt"
        	msg2="hrefs.txt content                        "
        	msg3="pics.txt content                         "
		msg4="number of gifs output to the terminal    "
		n2=0
		n3=0
		n4=0
		if [ -e hrefs.txt ]
		then
			n2=$( cat hrefs.txt | wc -c )
		fi
		if [ -e pics.txt ]
		then
			n3=$( cat pics.txt | wc -c )
		fi
		if [ -e q05.sh ]
		then
			n4=$(source q05.sh | tail -n 1 )
		fi
        	t2=$( [ $n2 -eq 4524 ]; echo $? ) 	# Modify as needed
        	check $t2 $n2 "$msg2"
        	t3=$( [ $n3 -eq 2447 ]; echo $? ) 	# Modify as needed
        	check $t3 $n3 "$msg3"
        	t4=$( [ $n4 -eq 7 ]; echo $? ) 	# Modify as needed
        	check $t4 $n4 "$msg4"
        	echo ""

	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

