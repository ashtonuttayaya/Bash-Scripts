#!/bin/bash
MYU=salesadmin
MYP=Larry12!
while read first last
do
	file="$first""_""$last"
	sql="$file"".sql"
	out="$file"".rpt"
	echo "use sales;" > $sql
	echo "select agent_id as \"Agent ID\" from agents where fname=\"$first\" and lname=\"$last\";" >> $sql
	echo "select dealers.name as \"Dealer Name\" from agents, dealers where agents.fname=\"$first\" and agents.lname=\"$last\" and dealers.dealer_id=agents.dealer_id;" >> $sql
	
	for y in {2010..2015}
	do
cat >> $sql << SQLS
select count(*) as "$y All Sales" from agents, sales_$y where agents.agent_id=sales_$y.agent_id and agents.fname="$first" and agents.lname="$last"; 
select count(*) as "$y New Sales" from agents, sales_$y where agents.agent_id=sales_$y.agent_id and sales_$y.sales_type="new" and agents.fname="$first" and agents.lname="$last"; 
SQLS

	done

	mysql -u $MYU -p$MYP < $sql > $out 2>/dev/null
done < agent_list

