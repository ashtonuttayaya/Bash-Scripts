#!/bin/bash
if [ $# -lt 1 ]
then
        echo "Error: script requires at least one integer parameter"
        exit
fi
total=0
for value in "$@"
do
total=$( echo "scale=1; $total+$value" | bc )
done
count=$#
ave=$( echo "scale=2; $total/$count" | bc )
echo "       Count = $#"
echo "       Sum   = $total"
echo "       Ave   = $ave"
echo ""
