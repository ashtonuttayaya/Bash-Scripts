#!/bin/bash
dir="junkdir"
if [ $# -gt 0 ]
then
dir="$1"
fi
if [ -e q02.sh ]
then
rm q02.sh
fi
ln -s ../q02/q02.sh q02.sh

if [ $# -lt 1 ] || [ ! -d "$dir"  ]
then
        echo "Error: script requires a valid diretory name"
        exit
fi
outfile="$dir"".rpt"
(

printf "Directory = %-25s %30s %10s\n" $dir "Date:" $(date +'%m-%d-%Y') > $outfile
#		       1         2         3         4         5         6         7         8 
#	      12345678901234567890123456789012345678901234567890123456789012345678901234567890
echo "" >> $outfile
printf "%-25s%9s   %5s   %5s   %9s   %6s   %6s\n" "Filename" "Chars" "Words" "Lines" "Bytes" "Wds/LN" "b/Char" >> $outfile
echo "================================================================================" >> $outfile
declare -a FILES
FILES=($(ls $dir/*.txt ))
for file in ${FILES[@]}
do
declare -a output
output=( $(./q02.sh $file) )
name=${output[0]}
output[0]=${output[0]/${dir}\//}
printf "%-25s%9s   %5s   %5s   %9s   %6.2f   %6.2f\n" ${output[@]} >> $outfile
done
echo "================================================================================" >> $outfile
)
