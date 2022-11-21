#!/bin/bash
#
# Script file for decryption process
# Version 1
# March 7, 2014
#
export CODE=$(pwd)

export OUTFILE=results.txt
echo "Using:   decode.sh" 		>  $OUTFILE
echo "Files:   $CODE/in" 		>> $OUTFILE
echo "Date:    $(date)"			>> $OUTFILE
echo "Command: $0" 			>> $OUTFILE
echo "From:    $(pwd)" 			>> $OUTFILE
echo File 1: encoded file: hello.txt
echo File 1: encoded file: hello.txt 	>> $OUTFILE
cat hello.txt	 			>> $OUTFILE
echo "" 				>> $OUTFILE
echo File 1: decoded file	 	>> $OUTFILE
$CODE/solution.pl hello	 		>> $OUTFILE
echo 					>> $OUTFILE
echo 					>> $OUTFILE
echo File 2: encoded file: quick.txt
echo File 2: encoded file: quick.txt 	>> $OUTFILE
cat quick.txt	 			>> $OUTFILE
echo "" 				>> $OUTFILE
echo File 2: decoded file	 	>> $OUTFILE
$CODE/solution.pl quick		 	>> $OUTFILE
echo 					>> $OUTFILE
echo 					>> $OUTFILE
echo File 3: encoded file: fsu.txt
echo File 3: encoded file: fsu.txt 	>> $OUTFILE
cat fsu.txt	 			>> $OUTFILE
echo "" 				>> $OUTFILE
echo File 3: decoded file	 	>> $OUTFILE
$CODE/solution.pl fsu		 	>> $OUTFILE
echo 					>> $OUTFILE
echo "See the file $OUTFILE for results"
