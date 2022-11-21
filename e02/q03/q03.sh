#!/bin/bash
inputYear=$1
if [ "$inputYear" -lt "2010" ] || [ "$inputYear" -gt "2015" ]; then
   echo "input year wrong"
   if [ -f "q03.sql" ]; then
      rm q03.sql
   fi
exit 1
fi

echo "USE sales;" > q03.sql
echo "SELECT COUNT(*) FROM sales_$inputYear;" >> q03.sql
echo "SELECT COUNT(*) FROM sales_$inputYear WHERE sales_type = 'used';" >> q03.sql
echo "SELECT COUNT(*) FROM sales_$inputYear WHERE sales_type = 'new';" >> q03.sql
mysql -u salesadmin -pWoodman123321 < q03.sql


