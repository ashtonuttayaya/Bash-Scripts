#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a03/q02")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a03/q02

fi
anum="a03"		# (a|h|e)XX
qnum="q02"		# qXX
rnum="02"		# text for question number
#
#
script=$qdir/check02.sh
script2=$qdir/script02.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/a03/q02'//}
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
#	Customize this output for the particular script or activity
#
if [ -e ~/.bash_aliases ]
then
        source ~/.bash_aliases
fi
if [ -e ~/myenv ]
then
        source ~/myenv
fi



if [ -e $script ]
then
	(
        	cd $qdir

        echo "Checking required files"
        msg1="~/.bash_aliases        "
        msg2="~/myenv                "
        msg3="vs                     "
        msg4="ve                     "
        msg5="rl                     "
        msg6="A3                     "
        msg7="MYTMP                  "
        n1=$( [ -e ~/.bash_aliases ] ; echo $? )
        n2=$( [ -e ~/myenv ] ; echo $? )
        n3=$( alias vs | grep -iE "alias vs='cat" | grep -iE '\$MYTMP/success.log' |wc -l )
        n4=$( alias ve | grep -iE "alias ve='cat" | grep -iE '\$MYTMP/error.log' |wc -l )
        n5=$( alias rl | grep -iE "alias rl='rm" | grep -iE '\$MYTMP/success.log' | grep -iE '\$MYTMP/error.log' | wc -l )
        n6=$( printenv A3 | grep -i "$HMOE/class/a03" | wc -l )
        n7=$( printenv MYTMP | grep -i "$HOME/tmp" | wc -l )
        v1=1
        v2=1
        v3=1
        v4=1
        v5=1     
        v6=1
        v7=1      
        t1=$( [ -e ~/.bash_aliases ] ; echo $? )        # Modify as needed
        t2=$( [ -e ~/myenv         ] ; echo $? )        # Modify as needed
        t3=$( [ $n3 -eq $v3 ] ; echo $? )       # Modify as needed
        t4=$( [ $n4 -eq $v4 ] ; echo $? )       # Modify as needed
        t5=$( [ $n5 -eq $v5 ] ; echo $? )       # Modify as needed
        t6=$( [ $n6 -eq $v6 ] ; echo $? )       # Modify as needed
        t7=$( [ $n7 -eq $v7 ] ; echo $? )       # Modify as needed
        check $t1 $n1 "$msg1"
        check $t2 $n2 "$msg2"
        echo ""
        echo "Checking aliases and environment variables"
        check $t3 $n3 "$msg3"
        check $t4 $n4 "$msg4"
        check $t5 $n5 "$msg5"
        check $t6 $n6 "$msg6"
        check $t7 $n7 "$msg7"

	echo ""
	if [ -e ~/myenv ]
	then
		cp ~/myenv myenv
	fi
	if [ -e ~/.bash_aliases ]
	then
		cp ~/.bash_aliases bash_aliases
	fi

	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi
