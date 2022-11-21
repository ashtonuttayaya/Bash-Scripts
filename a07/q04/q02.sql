USE sales;
SELECT COUNT(*), SUM(dealer_cost), SUM(price_sold), SUM(price_list) FROM sales_2015 WHERE model_name='Ridgeline' AND sales_type='used';
