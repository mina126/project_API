SELECT product_id, SUM(sale_price) AS sales 
FROM df_orders 
GROUP BY product_id 
ORDER BY sales DESC 
LIMIT 10;
