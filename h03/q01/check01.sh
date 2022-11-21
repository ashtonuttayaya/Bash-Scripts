#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"h03/q01")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/h03/q01

fi
anum="h03"		# (a|h|e)XX
qnum="q01"		# qXX
rnum="01"		# text for question number
#
#
script=$qdir/q01.sh
script2=$qdir/script01.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/h03/q01'//}
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
	code="chx""q01-""${csym[$cindex]}"
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
		n0=$( ./q01.sh | wc -l )
        	echo "Checking tar extraction"
        	msg4="tar command                           "
        	v4=1
        	n4=$( grep -i "tar" q01.sh | grep -i wildcards | grep -i "web.tar.gz" | grep -i html | wc -l )
        	t4=$( [ $n4 -eq $v4 ] ; echo $? )
		check $t4 $n4 "$msg4"
        	msg1="web directory and html file extraction"
        	v1=5
		v2=3
		v3=1
        	n1=$( ls -l *.html | wc -l)
		n2=$( ls -l s*.html | wc -l)
		if [ -d web ]
		then
			n3=1
		else
			n3=0
		fi
        	t1=$( [ $n1 -eq $v1 ] && [ $n2 -eq $v2 ] && [ $n3 -eq $v3 ] ; echo $? ) # Modify as needed
		c1=$(( n3+100*(n2 + 100*n1) ))
		check $t1 $c1 "$msg1"
        	echo ""

		echo "Checking grep commands"
		msg5="href counts by file                   "
		v5=282
		v6=9
		v7=136
		n5=$( ./q01.sh | grep -i href | wc -l)
		n6=$( ./q01.sh | grep -i href | grep -iE "sb.html|sgs.html|shs.html" | wc -l )
		n7=$( ./q01.sh | grep -i href web/lol.html | wc -l )
		t5=$( [ $n5 -eq $v5 ] && [ $n6 -eq $v6 ] &&  [ $n7 -eq $v7 ] ; echo $?)
		c5=$((  n7+1000*(n6 + 1000*n5)  ))
		check $t5 $c5 "$msg5"
		echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

