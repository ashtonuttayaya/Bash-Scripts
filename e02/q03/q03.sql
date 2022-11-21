USE sales;
SELECT COUNT(*) FROM sales_2014;
SELECT COUNT(*) FROM sales_2014 WHERE sales_type = 'used';
SELECT COUNT(*) FROM sales_2014 WHERE sales_type = 'new';
