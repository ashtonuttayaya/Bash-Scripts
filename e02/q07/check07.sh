#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"e02/q07")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/e02/q07

fi
anum="e02"		# (a|h|e)XX
qnum="q07"		# qXX
rnum="07"		# text for question number
#
#
script=$qdir/q07.sh
script2=$qdir/script07.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/e02/q07'//}
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
	code="chx""q07-""${csym[$cindex]}"
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
####

		ddat=(D25-22-02 "City Honda" D29-25-04 "Carter Honda" D14-13-09 "Donner Honda")
		adat=(361 381 490 467 430 656 419 302 252 179 220 265 107 139 88 139 97 157)
		ndat=(190 161 323 247 230 375 169 159 152 100 111 163 64 79 65 61 55 101)

		i=0
		files=0
		while read fn ln
		do
			f1="$fn""_""$ln"".sql"
			f2="$fn""_""$ln"".rpt"
			i=$((i+1))
			if [ -e $f1 ] && [ -e $f2 ]
			then
				files=$(( files + 1 ))
			fi
		done < agent_list
		t1=$( [ $files -eq $i ] ; echo $? )
		n1=$(( $files + 100 * $i ))
		if [ $files -eq $i ]
		then
			msg1="All expected files found              "

		else
			msg1="Missing some expected sql or rpt files"

		fi
		check $t1 $n1 "$msg1"
		all=0
		for test in "${ddat[@]}"
		do

			n=$(grep -i "$test" *.rpt 2> /dev/null | wc -l)
			if [ ! -z "$n" ]
			then
				if [ $n -eq 0 ]
				then
					msg2="At least one expected dealer value missing"
					all=$(( all + 1 ))
				fi 
			else
				msg2="At least one expected dealer value missing"
				all=$(( all + 1 ))

			fi
		done
		t2=$( [ $all -eq 0 ] ; echo $? )

		if [ $all -eq 0 ]
		then
			msg2="All expected dealer results found     "
		fi
		check $t2 $all "$msg2"

		all=0
		for test in "${adat[@]}"
		do
			n=$(grep -i "$test" *.rpt 2> /dev/null | wc -l)
			if [ ! -z "$n" ]
			then
				if [ $n -eq 0 ]
				then
					msg3="At least one expected total sales value missing"
					all=$(( all + 1 ))
				fi
			else
					msg3="At least one expected total sales value missing"
					all=$(( all + 1 ))
			fi
		done
		t3=$( [ $all -eq 0 ] ; echo $? )
		if [ $all -eq 0 ]
		then
			msg3="All expected total sales results found"
		fi
		check $t3 $all "$msg3"

		all=0
		for test in "${ndat[@]}"
		do
			n=$(grep -i "$test" *.rpt 2> /dev/null | wc -l)
			if [ ! -z "$n" ]
			then
				if [ $n -eq 0 ]
				then
					msg4="At least one expected new sales value missing"
					all=$(( all + 1 ))
				fi 
			else
					msg4="At least one expected new sales value missing"
					all=$(( all + 1 ))
			fi
		done
		t4=$( [ $all -eq 0 ] ; echo $? )
		if [ $all -eq 0 ]
		then
			msg4="All expected new sales results found  "
		fi
		check $t4 $all "$msg4"
        	echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

