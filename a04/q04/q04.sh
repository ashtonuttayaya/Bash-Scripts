#!/bin/bash

agents_sql=$(grep agent_id, *.sql | wc -l)
agents_txt=$(wc -l SALESDATA/agents.txt)

dealers_txt=$(grep -i honda SALESDATA/dealerships.txt | wc -l)
dealers_sql=$(grep dealer_id, dealers.sql | wc -l)

owners_sql=$(grep owner_id, owners.sql | wc -l)

alabama_sql=$(grep "'AL'," dealers.sql | wc -l) 
alabama_txt=$(grep ", AL" SALESDATA/dealerships.txt | wc -l)

walker_txt=$(grep -i "walker," SALESDATA/dealerships.txt | wc -l)
walker_sql=$(grep -i "'walker" owners.sql | wc -l)

echo "Initial Data File Counts"
echo "Agents: DATA =$agents_txt SQL = $agents_sql"
echo "Dealers: DATA = $dealers_txt SQL = $dealers_sql"
echo "Owners: DATA = $dealers_txt SQL = $owners_sql"
echo "Alabama: DATA = $alabama_txt SQL = $alabama_sql"
echo "Walker: DATA = $walker_txt SQL = $walker_sql"

