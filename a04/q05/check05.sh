#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a04/q05")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a04/q05

fi
anum="a04"		# (a|h|e)XX
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
        where=${where/'/a04/q05'//}
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
building=0
if [ $# -gt 0 ] 
then
        building=1
        cp solution05.txt a05.txt
fi

#
#	Set standard functions for checking routines
#
cindex=0
csym=( A B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI AJ AK AL AM AN AO AP AQ AR AS AT AU AV AW AX AY AZ )
#
#         0    1    2    3    4    5    6    7    8    9   10   11   12
array=(  52  243   34    2   11    1    4   20   38   77   40   12   52 )
sym=(  "A." "B." "C." "D." "E." "F." "G." "H." "I." "J." "K." "L." "M." )

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
sql=q05.sql
txt=a05.txt
if [ -e $script ]
then
	(
        	cd $qdir
        	echo "Checking for q05.sql and q05.txt"
        	msg1="q05.sql"
		msg2="q05.txt"
		msg3="part a "
		msg4="part b "
		msg5="part c "
		msg6="part d "
		msg7="part e "
		msg8="part f "
		msg9="part g "

        	n1=1					# Set expected value for test 1
        	n2=1				# Execute commands to set n1
        	t1=$( [ -e $sql ] ; echo $? )	# Modify as needed
		t2=$( [ -e $txt ] ; echo $? )	# Modify as needed
        	check $t1 $n1 "$msg1"
        	check $t2 $n2 "$msg2"
        	echo ""

                echo "Checking the sql statements in q05.sql"
		if [ -e $sql ]
		then
                	n3=$( grep -iEw select $sql | grep -iE count | grep -iEw "from\s+agents" | grep -iv dealers | grep -iv owners | grep -iv where | wc -l )
                	n4=$( grep -iEw select $sql | grep -iE count | grep -iEw "from\s+owners" | grep -iv dealers | grep -iv agents | wc -l )
                	n5=$( grep -iEw select $sql | grep -iE count | grep -iEw "from\s+agents" | grep -iEw where | grep -iE "fname\s*=" | grep -iE Bill | grep -iv owners | grep -iv dealers | grep -iv "City" | wc -l )
                	n6=$( grep -iEw select $sql | grep -iE count | grep -iEw "from\s+dealers" | grep -iEw where | grep -iE "city\s*=" | grep -iE Sawyer | grep -iE "TN" | grep -iE "state\s*=" | grep -iv owners | grep -iv agents | wc -l )
                	n7=$( grep -iEw select $sql | grep -iE count | grep -iEw "from\s+dealers" | grep -iEw where | grep -iE "state\s*=" | grep -iE AL | grep -iv owners | grep -iv agents | grep -iv "city" | wc -l )
                	n8=$( grep -iEw select $sql | grep -iE count | grep -iE agents | grep -iEw where | grep -iE Maureen | grep -iE Isern | grep -iE owners.owner_id |  grep -iE agents.owner_id | grep -iv dealers | wc -l )
                	n9=$( grep -iEw select $sql | grep -iE count | grep -iE owners | grep -iE dealers | grep -iEw where | grep -iE lname\s* | grep -iE Walker | grep -iE owners.owner_id | grep -iE dealers.owner_id | grep -iv agents | wc -l )

		else
			n3=0
			n4=0
			n5=0
			n6=0
			n7=0
			n8=0
			n9=0
		fi
		t3=$( [ $n3 -eq 1 ] ; echo $? )	# Modify as needed
        	check $t3 $n3 "$msg3"
		t4=$( [ $n4 -eq 1 ] ; echo $? )	# Modify as needed
        	check $t4 $n4 "$msg4"
		t5=$( [ $n5 -eq 1 ] ; echo $? )	# Modify as needed
        	check $t5 $n5 "$msg5"
		t6=$( [ $n6 -eq 1 ] ; echo $? )	# Modify as needed
        	check $t6 $n6 "$msg6"
		t7=$( [ $n7 -eq 1 ] ; echo $? )	# Modify as needed
        	check $t7 $n7 "$msg7"
		t8=$( [ $n8 -eq 1 ] ; echo $? )	# Modify as needed
        	check $t8 $n8 "$msg8"
		t9=$( [ $n9 -eq 1 ] ; echo $? )	# Modify as needed
        	check $t9 $n9 "$msg9"
                echo ""
                echo "Checking answers in a05.txt file"
                if [ $testing -eq 1 ]
                then
                        target="solution05.txt"
                else
                        target="a05.txt"
                fi
		v4=319
                msg4="a05.txt"
		n4=$(cat $target | wc -c )
                t4=$( [ $n4 -gt $v4 ] ; echo $? )
                check $t4 $n4 "$msg4"
		msgb="part b "
		msgc="part c "
		msgd="part d "
		msge="part e "
		msgf="part f "
		msgg="part g "
		msgh="part h "

                vb=${array[1]}
                vc=${array[2]}
                vd=${array[3]}
                ve=${array[4]}
                vf=${array[5]}
                vg=${array[6]}
                vh=${array[7]}
		nb=0
		nc=0
		nd=0
		ne=0
		nf=0
		ng=0
		nh=0
                nb=$( cat $target | grep -i "^${sym[1]}" | grep $vb | wc -l 2> /dev/null )
                nc=$( cat $target | grep -i "^${sym[2]}" | grep $vc | wc -l 2> /dev/null )
                nd=$( cat $target | grep -i "^${sym[3]}" | grep $vd | wc -l 2> /dev/null )
		ne=$( cat $target | grep -i "^${sym[4]}" | grep $ve | wc -l 2> /dev/null )
		nf=$( cat $target | grep -i "^${sym[5]}" | grep $vf | wc -l 2> /dev/null )
		ng=$( cat $target | grep -i "^${sym[6]}" | grep $vg | wc -l 2> /dev/null )
		nh=$( cat $target | grep -i "^${sym[7]}" | grep $vh | wc -l 2> /dev/null )
                tb=$( [ $nb -eq 1 ] ; echo $? )
                check $tb $nb "$msgb"
                tc=$( [ $nc -eq 1 ] ; echo $? )
                check $tc $nc "$msgc"
                td=$( [ $nd -eq 1 ] ; echo $? )
                check $td $nd "$msgd"
                te=$( [ $ne -eq 1 ] ; echo $? )
                check $te $ne "$msge"
                tf=$( [ $nf -eq 1 ] ; echo $? )
                check $tf $nf "$msgf"
                tg=$( [ $ng -eq 1 ] ; echo $? )
		check $tg $ng "$msgg"
                th=$( [ $nh -eq 1 ] ; echo $? )
                check $th $nh "$msgh"
                echo ""

	)
	if [ $building -gt 0 ] 
	then
        	cat a05.bak > a05.txt
	fi

else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

