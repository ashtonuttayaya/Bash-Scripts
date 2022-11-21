#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a06/q05")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a06/q05

fi
anum="a06"		# (a|h|e)XX
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
        where=${where/'/a06/q05'//}
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
		msg1="sales_v5.txt                                   "
		msg2="sales_v4.sql                                   "
		msg3="files match                                    "
                msg4="sales_v5 and dev_v4 sql files are consistent   "

	        na=$(ls sales_v5.* | grep -i sales_v5.sql | wc -l)
        	nb=$(ls sales_v5.* | grep -i sales_v5.txt | wc -l)

	        nc=0
	        for i in 259 36 41 40612 30836 60632 36296
	        do
        	        sn=$(grep -i "^$i$" sales_v5.txt | wc -l)
                	if [ $sn -ge 1 ]
                	then
                        	nc=$((nc+1))
                	fi
        	done

        	nd=0
        	for i in agents dealers owners 2012 2013 2016
        	do
                	sn=$(grep -i "$i" sales_v5.sql | wc -l)
                	if [ $sn -ge 1 ]
                	then
                        	nd=$((nd+1))
                	fi
        	done
		n1=$(( na*10 + nc ))
		n2=$(( nb*10 + nd ))
        	t1=$( [ $na -ge 1 ] && [ $nc -eq 7 ] ; echo $?)
	        t2=$( [ $nb -ge 1 ] && [ $nd -eq 6 ] ; echo $? )

#	        echo "Comparing dev_v4.txt and sales_v5.txt"
	        n3=$(diff ../q04/dev_v4.txt sales_v5.txt | grep "^>" | wc -l)

		if [ $n3 -ne 0 ] 
		then
			msg3="files don't match                                 "
		fi

		t3=$( [ $n3 -eq 0 ] ; echo $? )

#        echo "Comparing dev_v4.sql and sales_v5.sql"
	        cat ../q04/dev_v4.sql | grep -v "use dev" > .v64
	        cat sales_v5.sql | grep -v "use sales" > .v65
	        na=$(diff .v64 .v65 | wc -l)
	        rm .v64 .v65
	        nb=$(diff sales_v5.sql ../q04/dev_v4.sql | grep "^<" | wc -l )
	        nc=$(diff sales_v5.sql ../q04/dev_v4.sql | grep "^<" | grep -v "use sales" |  wc -l )
	        nd=$((nb-nc))
		t4=$( [ $na -eq 0 ] && [ $nb -eq 1 ] && [ $nc -eq 0 ] ; echo $? )
	        n4=$(( nb*100 + na*10 + nc ))

		if [ $na -eq 0 ] && [ $nb -eq 1 ] && [ $nc -eq 0 ]
	        then
	                msg4="sales_v5 and dev_v4 sql files are consistent   "
	        else
	                msg4="sales_v5 and dev_v4 sql files are not consistent"
	        fi

		echo "Checking sales_v5.txt and sales_v5.sql"
        	check $t1 $n1 "$msg1"
        	check $t2 $n2 "$msg2"
        	echo ""

	        echo "Comparing dev_v4.txt and sales_v5.txt"
        	check $t3 $n3 "$msg3"
        	echo ""

	        echo "Comparing dev_v4.sql and sales_v5.sql"
        	check $t4 $n4 "$msg4"
        	echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

