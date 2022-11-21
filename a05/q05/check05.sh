#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a05/q05")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a05/q05

fi
anum="a05"		# (a|h|e)XX
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
        where=${where/'/a05/q05'//}
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
	echo "44 9 473" > size
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
		for i in $(file * | grep broken | cut -d : -f 1); do rm $i; done
		if [ -e ../q01/env_mysql ]
		then
			if [ -e env_mysql ]
			then
				rm env_mysql
			fi
			ln -s ../q01/env_mysql env_mysql
		fi
#
#	Does the backupfile salesv00.sql.gz exist
#	How big was salesv00.sql
#	How big is salesv00.sql.gz
#	is the compression ratio correct
#
#
		if [ ! -e size ]
		then
			echo "1.0 2.0 100" > size
		fi 

		PARENT_COMMAND=$(ps $PPID | tail -n 1 | awk "{print \$5}")

		if [ "$PARENT_COMMAND" == "sh" ]
		then
			if [ ! -e size ]
			then
				echo "1.0 3.0 100" > size
			fi

		fi
                if [ "$PARENT_COMMAND" == "-bash" ] && [ $building -eq 0 ] 
                then
			y="n"
			until [ $y == "y" ]
			do
				echo -n "     Enter approximate size of salesv00.sql in MB's : "
                        	read mb1
                        	echo -n "     Enter approximate size of salesv00.sql.gz in MB's : "
                        	read mb2
                        	echo -n "     Enter approximate compression ratio in % : "
                        	read mb3
	                        echo "        uncompressed size  = $mb1 MB"
				echo "        compressed size    = $mb2 MB"
				echo "        compression ratio  = $mb3%"
				echo -n "Are the above correct? (y or n) : "
				read y
				echo ""
			done
                        echo $mb1 $mb2 $mb3 > size

		fi
		echo "Looking for salesv00.sql.gz"
		msg0="~/backup/salesv00.sql.gz not found"
		n0=0
		t0=$( [ -e ~/backup/salesv00.sql.gz ] ; echo $? )
		if [ -e ~/backup/salesv00.sql.gz ]
		then
			n0=1
			msg0="~/backup/salesv00.sql.gz found     "
		fi
		check $t0 $n0 "$msg0"
		echo ""

		echo "Checking file sizes"
		read rmb1 rmb2 rmb3 < size
		mb1=$(echo $rmb1 | awk '{print int($1+0.5)}')
		mb2=$(echo $rmb2 | awk '{print int($1+0.5)}')
		mb3=$(echo $rmb3 | awk '{print int($1+0.5)}')

		t1=$( [ $mb1 -gt 40 ] && [ $mb1 -lt 48 ] ; echo $? )
		if [ $mb1 -gt 40 ] && [ $mb1 -lt 48 ]
		then
			msg1="salesv00.sql about 42 MB           "
		else
			if [ $mb1 -le 40 ]
			then
				msg1="salesv00.sql size seems too small  "
			else
				msg1="salesv00.sql size seems too big    "
			fi
		fi		
		check $t1 $mb1 "$msg1"


                if [ $mb2 -ge 8 ] && [ $mb2 -le 10 ]
                then
			msg2="salesv00.sql.gz about 9 MB         "
		else
			if [ $mb2 -lt 8 ]
			then
				msg2="salesv00.sql.gz seems too small    "
			else
				msg2="salesv00.sql.gz seems too big      "
			fi
                fi
		t2=$( [ $mb2 -ge 8 ] && [ $mb2 -le 9 ] ; echo $? )
		check $t2 $mb2 "$msg2"


		arn=( $(./size.pl $mb1 $mb2 ) )
		cmp=${arn[2]}


		cr=$cmp
		cratiol=440
		cratioh=500

		cr2=$(echo $cr | awk '{print int($1+0.5)}')
		cratio2=$(echo $cratiol | awk '{print int($1-0.5)}')
		cratio3=$(echo $cratioh | awk '{print int($1+0.5)}')
 
		t3=$( [ $mb3 -ge $cratio2 ] && [ $mb3 -le $cratio3 ] ; echo $? )
		if [ $mb3 -ge $cratio2 ] && [ $mb3 -le $cratio3 ]
		then
			msg3="compression ratio around  470 %    "
		else
			if [ $mb3 -lt $cratio2 ]
			then
				msg3="ratio seems too small              "
			elif [ $mb3 -gt $cratio3 ]
			then
				msg3="ratio seems too large              "
			fi
		fi
		check $t3 $mb3 "$msg3"
		echo ""
		if [ $building -gt 0 ]
		then
			cat a05.bak > a05.txt
		fi
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

