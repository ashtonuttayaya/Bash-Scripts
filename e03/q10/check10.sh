#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"e03/q10")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/e03/q10

fi
anum="e03"		# (a|h|e)XX
qnum="q10"		# qXX
rnum="10"		# text for question number
#
#
script=$qdir/q10.sh
script2=$qdir/script10.sh
testing=$( echo $dir | grep -i create | wc -l ) # testing type flag
if [ $testing -eq 1 ]
then
        where=$( echo $dir )
        where=${where/'/e03/q10'//}
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
	code="chx""q10-""${csym[$cindex]}"
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
                echo "Examining Error Checking"
                n1=$($script Pokeymon | grep -i "Not Ranked" | wc -l )
                msg1="If title is not in database       "
                v1=1                                    # Set expected value for test 1
                t1=$( [ $n1 -eq $v1 ] ; echo $? )       # Modify as needed
                check $t1 $n1 "$msg1"
                n1=$($script | grep -i "No title" | wc -l )
                msg1="If no title was provided          "
                v1=1                                    # Set expected value for test 1
                t1=$( [ $n1 -eq $v1 ] ; echo $? )       # Modify as needed
                check $t1 $n1 "$msg1"
                n1=$($script Godfather | grep -i "Multiple Listing" | wc -l )
                msg1="If title is found more than once  "
                v1=1                                    # Set expected value for test 1
                t1=$( [ $n1 -eq $v1 ] ; echo $? )       # Modify as needed
                check $t1 $n1 "$msg1"
                echo ""

                echo "Checking functionality"
                msg1="Single word titles located        "
                v1=1
                n1=$( $script Gladiator | grep -i "Gladiator" | grep -w 2000 | grep -w 46 | grep -w 55225 | wc -l )
                t1=$( [ $n1 -eq $v1 ]; echo $? )        # Modify as needed
                check $t1 $n1 "$msg1"
                msg2="Multiple word titles located      "
                v2=1
                n2=$( $script "Groundhog Day" | grep -w "1993" | grep -w "231" | grep -w "118261" | wc -l )
                t2=$( [ $n2 -eq $v2 ]; echo $? )        # Modify as needed
                check $t2 $n2 "$msg2"
                msg2="Correct values returned           "
                t2=$( [ $n2 -eq $v2 ] && [ $n1 -eq $v1 ]; echo $? )        # Modify as needed
		n=$(( 100*n1 + n2 ))
                check $t2 $n "$msg2"
		echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

