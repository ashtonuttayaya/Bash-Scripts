use sales;
SELECT COUNT(agent_id) AS num_agents FROM agents;
SELECT COUNT(owner_id) AS num_owners FROM owners;
SELECT COUNT(dealer_id) AS num_dealers FROM dealers;
SELECT COUNT(sales_type) AS used_2010 FROM sales_2010 WHERE sales_type='used';
SELECT COUNT(sales_type) AS used_2011 FROM sales_2011 WHERE sales_type='used';
SELECT COUNT(sales_type) AS used_2012 FROM sales_2012 WHERE sales_type='used';
SELECT COUNT(sales_type) AS used_2013 FROM sales_2013 WHERE sales_type='used';
SELECT COUNT(sales_type) AS used_2014 FROM sales_2014 WHERE sales_type='used';
SELECT COUNT(sales_type) AS used_2015 FROM sales_2015 WHERE sales_type='used';
SELECT COUNT(sales_type) AS new_2010 FROM sales_2010 WHERE sales_type='new';
SELECT COUNT(sales_type) AS new_2011 FROM sales_2011 WHERE sales_type='new';
SELECT COUNT(sales_type) AS new_2012 FROM sales_2012 WHERE sales_type='new';
SELECT COUNT(sales_type) AS new_2013 FROM sales_2013 WHERE sales_type='new';
SELECT COUNT(sales_type) AS new_2014 FROM sales_2014 WHERE sales_type='new';
SELECT COUNT(sales_type) AS new_2015 FROM sales_2015 WHERE sales_type='new';

