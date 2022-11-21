#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"h01/q01")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/h01/q01

fi
anum="h01"		# (a|h|e)XX
qnum="q01"		# qXX
rnum="01"		# text for question number
#
#
script=$qdir/check01.sh
script2=$qdir/script01.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/h01/q01'//}
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
        	echo "Checking your directory structure and files"
		msg1="Directory structure   "
		msg2="Required files present"
		num=0
		v1=0
		v2=2
		v3=2
		v4=2
		v5=2
		if [ -e cars ]
		then
		        n1=$( ls -R cars | wc -l)
			if [ -e cars/toyota ]
			then
		        	n2=$( ls -R cars | grep -i toyota | wc -l )
			else
				n2=0
			fi
			if [ -e cars/ford ]
			then
			       	n3=$( ls -R cars | grep -i ford   | wc -l )
			else
				n3=0
			fi
			if [ -e cars/gm ]
			then
		        	n4=$( ls -R cars | grep -i gm     | wc -l )
        		else
				n4=0
			fi
			if [ -e cars/honda ]
			then
				n5=$( ls -R cars | grep -i honda  | wc -l )
			else
				n4=0
			fi
		else
			n1=0
		fi
		t1=$( [ $n1 -gt $v1 ] && [ $n2 -eq $v2 ] && [ $n3 -eq $v3 ] && [ $n4 -eq $v4 ] && [ $n5 -eq $v5 ] ; echo $? )
		num=$(( (n5+100*(n4 + 100*(n3+100*(n2+100*n1)))) ))
		check $t1 $num "$msg1"
		echo ""

		echo "Checking files"
		if [ -e cars/toyota ]
		then
		        n6=$( ls -RC cars/toyota| grep -i camry | grep -i prius | wc -l )			
		else
			n6=0
		fi

		if [ -e cars/honda ]
		then
		        n7=$( ls -RC cars/honda | grep -i accord | grep -i odyssey | wc -l )		
		else
			n6=0
		fi

		if [ -e cars/ford ]
		then
		        n8=$( ls -RC cars/ford | grep -i focus | grep -i f150 | wc -l )
		else
			n6=0
		fi

		if [ -e cars/gm ]
		then
		        n9=$( ls -RC cars/gm | grep -i corvette | grep -i equinox | wc -l )		
		else
			n6=0
		fi

		num=$(( ( n9 + 100*(n8 + 100*(n7 + 100*n6))) ))
		vnum=$(( ( 1 + 100*(1+100*(1+100*1))) ))
        	t2=$( [ $num -eq $vnum ]; echo $? ) # Modify as needed
        	check $t2 $num "$msg2"
		echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

