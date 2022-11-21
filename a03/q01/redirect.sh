#!/bin/bash
#
#	This script provides a simple of exame of how to redirect output resulting
#	from commands that executes properly and a command that does not.
#
echo -n "Please enter a filename: "
read name
echo "This file logs commands that succeed" > success.log
echo "This file logs commands that fail (execpt this one)" > error.log
#
#	If $name is found, the ls $name succeeds and its output will go into the success.log file
#	However, the echo will success and will still go into the success.log file
#
#	If $name is not found, the ls $name fails and its output will go into the error.log file
#	However, the echo will succeed and still go into the success.log file
#
ls $name >> success.log 2>> error.log; echo "We looked for file $name" >> success.log 2>> error.log


