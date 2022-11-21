#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a02/q03")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a02/q03

fi
anum="a02"		# (a|h|e)XX
qnum="q03"		# qXX
rnum="03"		# text for question number
#
#
script=$qdir/q03.sh
script2=$qdir/script03.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/a02/q03'//}
        if [ -e $where/testing ]
        then
                testing=1
                cp $script2 $script
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
        	echo "Checking for required files"
		for file in pinger.txt whoami.txt simple.txt q03.txt
		do
	        	msg="$file check   "
			if [ "$file" == "q03.txt" ]
			then
				msg="$file check      "
			fi
	        	v=1
	        	if [ -e $file ]
			then
				n=1
			else
				n=0
			fi
        		t=$( [ $n -eq $v ] ; echo $? )
        		check $t $n "$msg"
		done
        	echo ""

		echo "Checking file contents"
        	msg1="pinger.txt contents"
        	msg3="whoami.txt contents"
        	msg4="simple.txt contents"
		msg5="q03.txt contents   "
		v1=16
		v2=26
        	v3=7
		v4=3
		v5=18
		v6=27
		v7=11
		v8=3				 # Set expected value for test 3
#       Execute command to set n3
		if [ -e pinger.txt ]
		then
	        	n1=$( grep -i ping pinger.txt | wc -l )
			n2=$( grep -i "192.168.60" pinger.txt | wc -l)
		else
			n1=0
			n2=0
		fi
		if [ -e whoami.txt ]
		then
			n3=$( grep -i scanning whoami.txt | wc -l)
		else
			n3=0
		fi
		if [ -e simple.txt ]
		then
			n4=$( grep -i "./simple.sh" simple.txt | wc -l)
		else
			n4=0
		fi
		c1=$(( n2 + 100*n1 ))
        	t1=$( [ $n1 -eq $v1 ] && [ $n2 -eq $v2 ] ; echo $? ) # Modify as needed
        	t3=$( [ $n3 -eq $v3 ]; echo $? ) # Modify as needed
        	t4=$( [ $n4 -eq $v4 ]; echo $? ) # Modify as needed
		check $t1 $c1 "$msg1"
        	check $t3 $n3 "$msg3"
		check $t4 $n4 "$msg4"

		if [ -e q03.txt ]
		then
        		n5=$( grep -i ping q03.txt | wc -l )
			n6=$( grep -i "192.168.60" q03.txt | wc -l)
			n7=$( grep -i scanning q03.txt | wc -l)
			n8=$( grep -i "./simple.sh" q03.txt | wc -l)
		else
			n5=0
			n6=0
			n7=0
			n8=0
		fi
		c5=$(( n8 + 100*(n7+100*(n6+100*n5)) ))
        	t5=$( [ $n5 -eq $v5 ] && [ $n6 -eq $v6 ] && [ $n7 -eq $v7 ] && [ $n8 -eq $v8 ] ; echo $? ) # Modify as needed
        	check $t5 $c5 "$msg5"
        	echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

