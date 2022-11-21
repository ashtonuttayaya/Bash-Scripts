
#!/bin/bash
f1=$1
f2=$2
f3=$3
if [ -e headers.txt ]
then
rm headers.txt
fi
touch headers.txt

for f in $f1 $f2 $f3
do
if [ -e $f ]
then
echo "$f exists."
cat $f | head -n 3 >> headers.txt
else
echo "$f does not exist."
fi
done
