if [ -e files ]
then
rm -r files
fi
if [ -e stories ]
then
rm -r stories
fi
tar -xf q02files.tar

mkdir stories
mkdir stories/happy
mkdir stories/unhappy
mkdir stories/ok

mv files/happy.txt stories/happy/happy.txt
mv files/fun.txt stories/happy/fun.txt

mv files/sad.txt stories/unhappy/sad.txt
mv files/lonely.txt stories/unhappy/lonely.txt

mv files/soso.txt stories/ok/soso.txt

if [ -e files ]
then
rm -r files
fi
