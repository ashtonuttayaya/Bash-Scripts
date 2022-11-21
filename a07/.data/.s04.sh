#!/bin/bash
if [ $# -ne 1 ]
then
        echo "This script requires a parameter"
        echo "   model name"
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
#
#       Get a list of all the models in the databases
#
cat > q04.sql <<- 'SQL'
use sales;
select distinct(model_name) from sales_2010;
SQL

models=($(mysql -u $MYSQLU -p$MYSQLP < q04.sql | grep -v model_name))

#
#        Check the value provided against the list of models.
#


found=0
for m in "${models[@]}"
do
        if [ "$m" == "$value" ]
        then
              found=1
        fi
done
#
#  found = 1 ==> model requested is valid
#  found = 0 ==> model requested is invalid
#
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
        echo "      $type car sales" >> $of
        echo "                  Number    Dealer     Sales      List       Profit   Discount   Average  Average" >> $of
        echo "         Year      Sold      Cost      Value      Price      Total      Total     Profit  Discount" >> $of
        echo "       ========  =======  =========  =========  =========  =========  =========  =======  ========"    >> $of
        for year in {2010..2015}
        do
                salesdata=( $(./model.sh $year $value $type ) )
                number=${salesdata[1]}
                dcost=${salesdata[2]}
                psold=${salesdata[3]}
                plist=${salesdata[4]}
                profit=$(( psold - dcost ))
                discount=$(( plist - psold ))
                ap=$(echo "scale=2;$profit/$number" | bc)
                ad=$(echo "scale=2;$discount/$number" | bc)
                printf "         %4s %9s %11s %10s %10s %10s %10s %8s %9s\n" $( echo "${salesdata[@]} $profit $discount $ap $ad") >> $of
        done

        echo "       =============================================================================================" >> $of
        echo "" >> $of
done
