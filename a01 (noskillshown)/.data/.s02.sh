#!/bin/bash
dir=`pwd`
flag=`echo $dir|awk '{print match($0,"a01/q02")}'`;
if [ $flag -gt 0 ]
then
	qdir=$dir
else
	qdir=$dir/a01/q02

fi
anum="a01"		# (a|h|e)XX
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
        where=${where/'/a01/q02'//}
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



if [ -e $script ]
then
	(
        	cd $qdir
        	echo "Checking apache web server configuration"
        	msg1="apache running"
        	v1=1
        	n1=$( ps -aef | grep -i apache2 | grep -i root | wc -l)
        	t1=$( [ $n1 -ge $v1 ] ; echo $? ) # Modify as needed
        	check $t1 $n1 "$msg1"

        	msg2="user web pages enabled"
        	v2=16
		v3=66
        	n2=$( cat /etc/apache2/mods-enabled/userdir.conf | wc -l )
        	n3=$( cat /etc/apache2/mods-enabled/userdir.load | wc -c )
        	t2=$( [ $n2 -gt $v2 ] && [ $n3 -eq $v3 ]; echo $? ) # Modify as needed
		num=$(( n3 + 100*n2 ))
        	check $t2 $num "$msg2"
		echo ""

		echo "Checking user web pages"

        	msg3="web pages"
        	msg4="web tar file"
        	v3=6
		v4=30
	        index=$HOME/public_html/index.html
	        shs=$HOME/public_html/shs.html
	        new=$HOME/public_html/new.html
	        used=$HOME/public_html/used.html
	        png=$HOME/public_html/Logo.png
	        tar=web.tar.gz
	        n3=$( ls $index $shs $new $used $png $tar 2>/dev/null | wc -w )
	        if [ -e $tar ] 
	        then
	                n4=`tar -tvf $tar | wc -w`
	        else
	                n4=0
	        fi
        	t3=$( [ $n3 -eq $v3 ]; echo $? ) # Modify as needed
        	check $t3 $n3 "$msg3"
        	t4=$( [ $n4 -eq $v4 ]; echo $? ) # Modify as needed
        	check $t4 $n4 "$msg4"
        	echo ""
	)
else
	echo "$script not found - INCOMPLETE SOLUTION"
fi

