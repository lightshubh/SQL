SELECT 
	primary_product_id,
    COUNT(DISTINCT CASE WHEN items_purchased= 1 THEN order_id ELSE NULL END) AS count_single_item,
    COUNT(DISTINCT CASE WHEN items_purchased= 2 THEN order_id ELSE NULL END) AS count_double_item
FROM orders
WHERE order_id BETWEEN 31000 AND 32000
GROUP BY 1;

