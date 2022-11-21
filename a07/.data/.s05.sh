#!/bin/bash
if [ ! -e env_mysql ]
then
        ln  -s ../q01/env_mysql env_mysql
fi
source env_mysql


cat > q05.sql << SQL
use sales;
select distinct(model_name) from sales_2010;
SQL

models=($(mysql -u $MYSQLU -p$MYSQLP < q05.sql 2>/dev/null | grep -v model_name))

for i in "${models[@]}"
do
        (       cd ../q04
                ./q04.sh $i
                if [ -e report.tmp ]
                then
                        cp report.tmp "$REPORTS/$i"".txt"
                        rm report.tmp
                fi
        )
done

(
        cd $REPORTS
        reports=( $(ls *.txt) )
        tar -cf models.tar ${reports[@]}
        mv models.tar ~/archive
)

