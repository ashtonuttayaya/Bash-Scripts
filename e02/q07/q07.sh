#!/bin/bash

while read -r fname lname; do
   fileName="${fname}_${lname}.sql"
   echo "USE sales;" > $fileName
   echo "SELECT agent_id FROM agents WHERE fname='$fname' and lname='$lname';" >> $fileName
   echo "SELECT name FROM dealers INNER JOIN agents ON agents.dealer_id = dealers.dealer_id WHERE agents.fname='$fname' AND agents.lname='$lname';" >> $fileName
   echo "SELECT COUNT(*) FROM sales_2010 INNER JOIN agents ON agents.agent_id = sales_2010.agent_id WHERE agents.fname='$fname' and agents.lname='$lname';" >> $fileName 
   echo "SELECT COUNT(*) FROM sales_2011 INNER JOIN agents ON agents.agent_id = sales_2011.agent_id WHERE agents.fname='$fname' and agents.lname='$lname';" >> $fileName
   echo "SELECT COUNT(*) FROM sales_2012 INNER JOIN agents ON agents.agent_id = sales_2012.agent_id WHERE agents.fname='$fname' and agents.lname='$lname';" >> $fileName
   echo "SELECT COUNT(*) FROM sales_2013 INNER JOIN agents ON agents.agent_id = sales_2013.agent_id WHERE agents.fname='$fname' and agents.lname='$lname';" >> $fileName
   echo "SELECT COUNT(*) FROM sales_2014 INNER JOIN agents ON agents.agent_id = sales_2014.agent_id WHERE agents.fname='$fname' and agents.lname='$lname';" >> $fileName
   echo "SELECT COUNT(*) FROM sales_2015 INNER JOIN agents ON agents.agent_id = sales_2015.agent_id WHERE agents.fname='$fname' and agents.lname='$lname';" >> $fileName
   echo "SELECT COUNT(*) FROM sales_2010 INNER JOIN agents ON agents.agent_id = sales_2010.agent_id WHERE agents.fname='$fname' and agents.lname='$lname' and sales_type='new';" >> $fileName
   echo "SELECT COUNT(*) FROM sales_2011 INNER JOIN agents ON agents.agent_id = sales_2011.agent_id WHERE agents.fname='$fname' and agents.lname='$lname' and sales_type='new';" >> $fileName
   echo "SELECT COUNT(*) FROM sales_2012 INNER JOIN agents ON agents.agent_id = sales_2012.agent_id WHERE agents.fname='$fname' and agents.lname='$lname' and sales_type='new';" >> $fileName
   echo "SELECT COUNT(*) FROM sales_2013 INNER JOIN agents ON agents.agent_id = sales_2013.agent_id WHERE agents.fname='$fname' and agents.lname='$lname' and sales_type='new';" >> $fileName
   echo "SELECT COUNT(*) FROM sales_2014 INNER JOIN agents ON agents.agent_id = sales_2014.agent_id WHERE agents.fname='$fname' and agents.lname='$lname' and sales_type='new';" >> $fileName
   echo "SELECT COUNT(*) FROM sales_2015 INNER JOIN agents ON agents.agent_id = sales_2015.agent_id WHERE agents.fname='$fname' and agents.lname='$lname' and sales_type='new';" >> $fileName
   mysql -u salesadmin -pWoodman123321 < $fileName > "${fname}_${lname}.rpt"
done < agent_list


