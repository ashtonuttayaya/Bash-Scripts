#!/bin/bash
if [ $# -lt 1 ]
then
        echo "Error: script requires at least one integer parameter"
        exit
fi
min="$1"
max="$1"
total=0
for value in "$@"
do
total=$(( total + value ))
if [ $value -lt $min ]
then
min=$value
fi
if [ $value -gt $max ]
then
max=$value
fi

done

echo "       Count = $#"
echo "       Sum   = $total"
echo "       Min   = $min"
echo "       Max   = $max"
echo ""
