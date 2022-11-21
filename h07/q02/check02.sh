#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"h07/q02")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/h07/q02

fi
script=$qdir/check02.sh
script2=$qdir/script02.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
	where=$( echo $dir )
	where=${where/'/h07/q02'//}
	if [ -e $where/testing ]
	then
		testing=1
		if [ -e $script2 ]
		then
			cp $script2 $script
		fi
	else
		testing=0
	fi
fi
#==========================
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
# Customize this output for the particular script or activity
#

if [ -e $script ]
then
#
# Customize these commands for the particular script or activity
#
	echo "Checking q02.env"
	(
		cd $qdir
		echo "describe sales.agents;" > .c02
		t1=$( [ -e q02.env ]; echo $? )
		if [ -e q02.env ] 
		then
			msg1="q02.env found                                          "
			n1=0
			check $t1 $n1 "$msg1"
			source q02.env
			n1=$(printenv MYSQL_ADMIN | wc -l)
			n2=$(printenv MYSQL_MGR | wc -l)
			n3=$(printenv MYSQL_PAD | wc -l)
			n4=$(printenv MYSQL_PMG | wc -l)
			n=$(( n1 + n2 + n3 + n4 ))
			t=$( [ $n -ge 4 ]; echo $? )
			if [ $n -ge 4 ]
			then
				msg="MYSQL_ADMIN, MYSQL_MGR, MYSQL_PAD and MYSQL_PMG defined"
				check $t $n "$msg"
				n5=$(mysql -u $MYSQL_ADMIN -p$MYSQL_PAD < .c02 2>/dev/null | grep agent_id | grep PRI | wc -l)
				v5=1
				t5=$( [ $n5 -ge $v5 ]; echo $? )
				msg5=" "
				if [ $n5 -ge 1 ]
				then
					msg5="MYSQL_ADMIN and MYSQL_PAD work as defined              "
				else
					msg5="MYSQL_ADMIN and MYSQL_PAD don't work as defined        "
				fi
				check $t5 $n5 "$msg5"

				n6=$(mysql -u $MYSQL_MGR -p$MYSQL_PMG < .c02 2>/dev/null | grep agent_id | grep PRI | wc -l)
				t6=$( [ $n6 -ge 1 ]; echo $?)
				msg6=" "
				if [ $n6 -ge 1 ]
				then
					msg6="MYSQL_MGR and MYSQL_PMG work as defined                "
				else
					msg6="MYSQL_MGR and MYSQL_PMG don't work as defined          "
				fi
				check $t6 $n6 "$msg6"

			else
				msg="MYSQL_ADMIN, MYSQL_MGR, MYSQL_PAD and MYSQL_PMG not all defined"
				check $t $n "$msg"
			fi 
		else
			msg1="q02.env not found                                      "
			n1=1
			check $t1 $n1 "$msg1"

		fi
		rm .c02

	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi
echo ""
