#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"h07/q03")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/h07/q03
fi
script=$qdir/q03.sh
script2=$qdir/script03.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
	where=$( echo $dir )
	where=${where/'/h07/q03'//}
	if [ -e $where/testing ]
	then
		testing=1
		cp $script2 $script
	else
		testing=0
	fi
fi

#
#       Set standard functions for checking routines
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
# Customize this output for the particular script or activity
#

if [ -e $script ]
then
#
# Customize these commands for the particular script or activity
#
(
	cd $qdir;	
	echo "Checking for script q03.sh"
	n=0;
	if [ -e q03.sh ]
	then
		n=$(cat q03.sh | wc -l)

		if [ $n -gt 0 ]
		then
			msg="q03.sh exists and is not empty                            "
		else
			msg="q03.sh exists, but is empty                               "
		fi
	else
		msg="q03.sh hasn't been created"
	fi
	t=$( [ $n -gt 0 ]; echo $? )
	check $t $n "$msg"
	echo ""
	echo "Checking for q03.sql"
	if [ -e q03.sql ]
	then
		n=$(grep -io select q03.sql | wc -l)
		if [ $n -gt 0 ]
		then
			msg="q03.sql exists and contains at least 1 select statement   "
		else
			msg="q03.sql exists, but does not contain any select statements"
		fi
		t=$( [ $n -gt 0 ]; echo $? )
		check $t $n "$msg"
		echo ""
		echo "Checking contents for q03.sql"
		n1=$(head -n 1 q03.sql | grep -i "USE sales;" | wc -l)
		if [ $n1 -gt 0 ]
		then
			msg1="\"use sales;\" statement present                            "
		else
			msg1="\"use sales;\" statement not present                        "
		fi
		t1=$( [ $n1 -gt 0 ]; echo $? )
		check $t1 $n1 "$msg1"

		n2=$(grep "FROM owners" q03.sql | grep -i "owner_id="| grep -i fname | grep -i lname | wc -l)
		msg2="select from owners statements                             "
		t2=$( [ $n2 -eq 34 ]; echo $? ) 
		check $t2 $n2 "$msg2"

		n3=$(grep "FROM dealers" q03.sql | grep -i "owner_id=" | grep -i count | wc -l)
		t3=$( [ $n3 -eq 34 ]; echo $? )
		msg3="select from dealers statements                            "
		check $t3 $n3 "$msg3"

		n4=$(grep "FROM agents" q03.sql | grep -i "owner_id="| grep -i fname | grep -i lname |  wc -l)
		msg4="select from agents statements                             "
		t4=$( [ $n4 -eq 34 ]; echo $? )
		check $t4 $n4 "$msg4"

	else
		echo "          Not OK - q03.sql hasn't been created"
	fi
	echo ""
)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

