
#!/bin/bash
if [ $# -ne 1 ]
then
        echo "This script requires a valid model name as a parameter"
fi

if [ ! -e model.sh ]
then
        ln  -s ../q02/q02.sh model.sh
fi
if [ ! -e env_mysql ]
then
        ln  -s ../q01/env_mysql env_mysql
fi
source env_mysql

value=$1
of="report.tmp"
if [ -e $of ]
then
        rm $of
fi
touch $of
cat > q03.sql <<- 'SQL'
use sales;
select distinct(model_name) from sales_2010;
SQL

models=($(mysql -u $MYSQLU -p$MYSQLP < q03.sql | grep -v model_name))

found=0
for m in "${models[@]}"
do
        if [ "$m" == "$value" ]
        then
                found=1
        fi
done
if [ $found -ne 1 ]
then
        echo "Invalid model name: $value"
        if [ -e report.tmp ]
        then
                rm report.tmp
        fi
        exit
fi
echo "Sales, Profit and Discount Report for Model = $value" >> $of
echo "" >> $of
for type in all new used
do
        echo "     $type Car Sales" >> $of
        echo "                  Number    Dealer     Sales      List     " >> $of
        echo "         Year      Sold      Cost      Value      Price    " >> $of
        echo "       ========  =======  =========  =========  =========  " >> $of
        for year in {2010..2015}
        do
                salesdata=( $(./model.sh $year $value $type ) )
                number=${salesdata[1]}
                dcost=${salesdata[2]}
                psold=${salesdata[3]}
                plist=${salesdata[4]}
                printf "         %4s %9s %11s %10s %10s\n" $( echo "${salesdata[@]}") >> $of
        done
        echo "       ==================================================  " >> $of
        echo "" >> $of
done
