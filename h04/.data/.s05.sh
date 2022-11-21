#!/bin/bash
input="quizzes.dat"	# This the default setting for the input file.  
output="quizzes.sql"	# Same as above - for output file
			# The above values need to be reset based on user command line parameter
# MAKE YOUR CHANGES HERE
if [ ! -z "$1" ]
then
        input="$1"
fi
if [ ! -z "$2" ]
then
        output="$2"
fi
if echo "$output" | grep -q ".sql$"
then
	echo -n ""
else
	echo "bad output file extension"
	exit
fi
if echo "$input" | grep -q ".dat$"
then
	echo -n ""
else
	echo "bad input file extension"
	exit
fi

if [ ! -e $input ]
then
	echo "input file does not exist"
	exit
fi

# END YOUR CHANGES HERE
#
# NOTE:  DO NOT CHANGE THE FILE FROM THIS POINT ON
#
#
# create the sql header to select the database to use and the table to use/create
#
echo "USE quizzes;" > $output
echo "CREATE IF NOT EXISTS TABLE students(score_id INT, student_id INT, fname VARCHAR(25), lname VARCHAR(25), quiz_id INT, quiz_score INT, primary key(score_id));" >> $output
#
#	Define a function to help insert the quiz scores
#
function insert() {
	sid=$1		#student id
	qid=$2		#quiz number
	fn=$3		#first name
	ln=$4		#last name
	qs=$5		#quiz score
	entry_id=$[($sid-1)*7 + $qid]		# calculate unique quiz id from student id and quiz id
#
#	Begin insert
#
	echo -n "INSERT INTO students( student_id, fname, lname, quiz_id, quiz_score, score_id ) "
	echo "VALUES( '$sid', '$fn, '$ln', '$qid', '$qs', '$entry_id');"

}	# end function insert	

#
#	Begin loop to read the data file and write out the student quiz scores
#
while read student_id fname lname q01 q02 q03 q04 q05 q06 q07
do							# write our sql statements for:
	insert $student_id 1 $fname $lname $q01 >> $output	# quiz 1
	insert $student_id 2 $fname $lname $q02	>> $output	# quiz 2
	insert $student_id 3 $fname $lname $q03	>> $output	# quiz 3
	insert $student_id 4 $fname $lname $q04	>> $output	# quiz 4
	insert $student_id 5 $fname $lname $q05	>> $output	# quiz 5
	insert $student_id 6 $fname $lname $q06	>> $output	# quiz 6
	insert $student_id 7 $fname $lname $q07	>> $output	# quiz 7
done < $input
