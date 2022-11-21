#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a03/q03")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a03/q03

fi
anum="a03"		# (a|h|e)XX
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
        where=${where/'/a03/q03'//}
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
		n0=0
		n1=0
		n2=0
		v3=2
		v4=2
		n0=$( grep -ioE "MYTMP" q03.sh | wc -w )
		t0=$( [ -e q03.sh ] && [ $n0 -ge 4 ] ; echo $? )
		t2=$( [ -e ~/bin/finder.sh ] ; echo $? )
		t1=$( [ -e ~/backup/finder_v02.sh ] ; echo $? )
		msg0="q03.sh              "
		msg1="finder_v02.sh       "
		msg2="finder.sh           "
		msg3="success.log         "
		msg4="error.log           "
                msg5="user count in logs  "
		if [ -e ~/bin/finder.sh ] && [ -e finder.in ]
		then
			finder.sh < finder.in > /dev/null
		fi
		if [ -e $HOME/tmp/success.log ]
		then
                	n3=$( cat $HOME/tmp/success.log | wc -l )
                fi
		if [ -e $HOME/tmp/error.log ]
		then
                	n4=$( cat $HOME/tmp/error.log | wc -l )
                fi
                t3=$( [ -e $HOME/tmp/success.log ] && [ $n3 -gt $v3 ] ; echo $? )
                t4=$( [ -e $HOME/tmp/error.log ]   && [ $n4 -gt $v4 ] ; echo $? )

                check $t0 $n0 "$msg0"
                check $t1 $n1 "$msg1"
                check $t2 $n2 "$msg2"
                echo ""

                echo "Looking for log files"
                check $t3 $n3 "$msg3"
                check $t4 $n4 "$msg4"
                echo ""
                
                echo "Checking log file contents"
                total=0
                found=0
		x5=0
                for homedir in /home/*
                do
                        flag=`echo $homedir|awk '{print match($0,"/home/")}'`;
                        if [ $flag -gt 0 ]
                        then
                                blank=""
                                user=${homedir/\/home\//$blank}
                        else
                                user="not_found"
                        fi
                        if [ -e $MYTMP/success.log ] && [ -e $MYTMP/error.log ]
                        then
                                f1=$( cat $MYTMP/success.log $MYTMP/error.log | grep -i $user | wc -l )
				# DEBUG CODE: 
				# echo -n "success.log total=$total user=$user f1=$f1 : ";cat $MYTMP/success.log | grep -i $user | wc -l
				# DEBUG CODE: 
				# echo -n "error.log   total=$total user=$user f1=$f1 : "; cat $MYTMP/error.log | grep -e $user | wc -l
				if [ $f1 -gt 0 ]
				then
	                                found=$(( found + 1 ))
				fi

                        fi
                        total=$(( total + 1 ))
                done
		if [ -e $MYTMP/success.log ] && [ -e $MYTMP/error.log ]
		then
			x1=$( cat $MYTMP/success.log | grep "/home/" | wc -l )
			x2=$( cat $MYTMP/error.log | grep "/home/" | wc -l )
			x5=$(( x1 + x2 ))
		fi
		v5=$total
		n5=$found
		nc=$(( x5 + 100*n5 ))
		t5=$( [ $n5 -eq $v5 ] || [ $x5 -eq $v5 ]; echo $? )
		check $t5 $nc "$msg5"
		echo ""

	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

