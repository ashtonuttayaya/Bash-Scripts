#!/bin/bash
if [ ! -e ~/reports ]
then
     mkdir ~/reports
fi
if [ ! -e ~/archive ]
then
     mkdir ~/archive
fi
if [ ! -e env_mysql ]
then
     echo "export MYSQLU=salesadmin" > env_mysql
     echo "export MYSQLP=Larry12!" >> env_mysql
     echo "export REPORTS=~/reports" >> env_mysql
     echo "export ARCHIVE=~/archive" >> env_mysql
fi

rm ../q02/env_mysql 2> /dev/null
rm ../q03/env_mysql 2> /dev/null
rm ../q04/env_mysql 2> /dev/null
rm ../q05/env_mysql 2> /dev/null

if [ ! -e env_mysql ]
then
     exit
fi
qdir=$(pwd)

for dir in q02 q03 q04 q05
do
(
     cd ../$dir
     if [ -e env_mysql ]
     then
          rm env_mysql
     fi
     ln -s $qdir/env_mysql env_mysql
)
done
