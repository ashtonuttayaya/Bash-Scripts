#!/bin/bash
#
#	Used for Activity 3, Question 2
#	script03.sh and finder_v02.sh 
#	version 01
#
#	Check to see if we have an aliases file
#	if so, execute it
#
if [ -f ~/.bash_aliases ] ; then
	shopt -s expand_aliases
	source ~/.bash_aliases
fi

efile=$MYTMP/error.log
sfile=$MYTMP/success.log

#
# Now look for implemented files (bin, class, tmp and public_html are good examples)
#
#	Get the file name from user input

echo -n "What file would you like to look for (good choices are bin, test, mbox, Mail and public_html)"
read file

echo "Searching for $file"

echo "OK, This is a list of where $file was found" 	> $sfile		# This should output to success.log
echo "Oh no!  $file wasn't found here."			> $efile		# This should output to error.log

echo "Found $file"					>> $sfile		# This should output to success.log
echo "Did NOT find $file"				>> $efile		# This should output to error.log

for homedir in /home/*
	do ls --directory --size "$homedir/$file" >> $sfile 2>> $efile	# This output should go to success.log(if found) or error.log(if not found)
done

vs >  $MYTMP/summary03.log 2> /dev/null
ve >> $MYTMP/summary03.log 2> /dev/null

