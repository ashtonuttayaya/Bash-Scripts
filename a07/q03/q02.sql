USE sales;
SELECT COUNT(*), SUM(dealer_cost), SUM(price_sold), SUM(price_list) FROM sales_2015 WHERE model_name='Accord' AND sales_type='used';
