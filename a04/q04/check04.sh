#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a04/q04")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a04/q04

fi
anum="a04"		# (a|h|e)XX
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
        where=${where/'/a04/q04'//}
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

        	echo "Looking for q04.sh"
        	msg1="q04.sh            "
		msg2="agents.sql        "
		msg3="dealers.sql       "
		msg4="owners.sql        "
		msg5="SALESDATA files   "
		msg6="Agent count       "
		msg7="Dealer count      "
		msg8="Owner count       "
		msg9="Alabama count     "
		msg10="Walker count      "
        	n1=1					# Execute commands to set n1
        	t1=$( [ -e q04.sh ] ; echo $? )		# Modify as needed
        	check $t1 $n1 "$msg1"
        	echo ""
		echo "Checking soft links"
		n2=0
		n3=0
		n4=0
		n5=0
        	t2=$( [ -L agents.sql  ] && [ -e agents.sql  ] ; echo $? ) 	# Modify as needed
        	t3=$( [ -L dealers.sql ] && [ -e dealers.sql ] ; echo $? ) 	# Modify as needed
        	t4=$( [ -L owners.sql  ] && [ -e agents.sql  ] ; echo $? ) 	# Modify as needed
        	t5=$( [ -L SALESDATA   ] && [ -e SALESDATA/agents.txt ] && [ -e SALESDATA/dealerships.txt ] ; echo $? ) 	# Modify as needed
#        	check $t2 $n2 "$msg2"
#        	check $t3 $n3 "$msg3"
#        	check $t4 $n4 "$msg4"
#        	check $t5 $n5 "$msg5"
		t0=$( [ $t2 -eq 0 ] && [ $t3 -eq 0 ] && [ $t4 -eq 0 ] && [ $t5 -eq 0 ] ; echo $? )
		msg0="soft links        "
		check $t0 0 "$msg0"
        	echo ""

		echo "Checking q04.sh output"
		./q04.sh > tmp04.out 2>/dev/null
	        n1=$(cat tmp04.out | grep -i "agents" | grep -i data | grep -i sql | wc -l ) 
	        n2=$(cat tmp04.out | grep -i "dealers" | grep -i data | grep -i sql | wc -l ) 
	        n3=$(cat tmp04.out | grep -i "owners" | grep -i data | grep -i sql | wc -l ) 
	        n4=$(cat tmp04.out | grep -i "alabama" | grep -i data | grep -i sql | wc -l ) 
	        n5=$(cat tmp04.out | grep -i "walker" | grep -i data | grep -i sql | wc -l )
		function vcheck {
			n=0
			n=$(grep -i $3 tmp04.out | grep -iw "DATA\s*=\s*$1" | grep -iw "SQL\s*=\s*$2" | wc -l 2> /dev/null )
			return
		} 
		vcheck 243 243 Agents
		n6=$n
                vcheck 39 39 Dealers
		n7=$n
                vcheck 39 34 Owners
		n8=$n
                vcheck 11 11 Alabama
		n9=$n
                vcheck 4 2 Walker
		n10=$n
		t6=$( [ $n1 -eq 1 ] && [ $n6 -eq 1 ] ; echo $? )
		t7=$( [ $n2 -eq 1 ] && [ $n7 -eq 1 ] ; echo $? )
		t8=$( [ $n3 -eq 1 ] && [ $n8 -eq 1 ] ; echo $? )
		t9=$( [ $n4 -eq 1 ] && [ $n9 -eq 1 ] ; echo $? )
		t10=$( [ $n5 -eq 1 ] && [ $n10 -eq 1 ] ; echo $? )
        	check $t6 $n6 "$msg6"
        	check $t7 $n7 "$msg7"
        	check $t8 $n8 "$msg8"
        	check $t9 $n9 "$msg9"
        	check $t10 $n10 "$msg10"
		echo ""

                rm tmp04.out
 
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

