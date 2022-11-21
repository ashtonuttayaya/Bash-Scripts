#!/bin/bash
nstart=$(diff backup target | wc -l )
if [ $nstart -gt 0 ]
then
cp backup target
fi
nstart=$(diff backup target | wc -l )
sed -i 's/KEY/Answer Key/g' target
sed -i 's/OK/Great!/g' target

na=$(diff backup target | grep "Answer Key" | wc -l)
ng=$(diff backup target | grep "Great!" | wc -l)
echo "Number of differences at the start     : $nstart"
echo "Number of changes made with KEY change : $na"
echo "Number of changes made with OK change  : $ng"
