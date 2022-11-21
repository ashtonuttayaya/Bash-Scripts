#!/bin/bash
USE sales;
SELECT COUNT(*) FROM sales_2010;
SELECT COUNT(*) FROM sales_2013 WHERE sales_month='Jul';
SELECT COUNT(*) FROM sales_2015 WHERE model_name='Odyssey';
SELECT COUNT(*) FROM sales_2014 WHERE agent_id='D36-32-04';
SELECT price_sold-dealer_cost FROM sales_2012 WHERE vin='JE142FU154525XBX8';

