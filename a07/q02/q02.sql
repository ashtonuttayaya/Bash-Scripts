USE sales;
SELECT COUNT(*), SUM(dealer_cost), SUM(price_sold), SUM(price_list) FROM sales_2013 WHERE model_name='Fit' AND sales_type='used';
