#!/bin/bash

rm env_mysql

echo export MYSQLU='salesadmin' > env_mysql
echo export MYSQLP='Woodman123321' >> env_mysql
echo export REPORTS="$HOME/reports" >> env_mysql
echo export ARCHIVE="$HOME/archive" >> env_mysql

for int in {2..5}
do
cd ../q0$int
ln -s $HOME/class/a07/q01/env_mysql env_mysql
done
