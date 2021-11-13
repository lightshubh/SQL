SELECT 
    (CASE WHEN website_sessions.created_at < "2013-12-12" THEN 'A. Pre_Birthday_Bear' ELSE 'B. Pre_Birthday_Bear' END) AS time_period,
	COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS conv_rt,
    SUM(price_usd) / COUNT(DISTINCT orders.order_id) AS AOV,
    SUM(items_purchased) / COUNT(DISTINCT orders.order_id) AS products_per_order,
    SUM(price_usd) / COUNT(DISTINCT website_sessions.website_session_id) AS revenue_per_session
    
    
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at BETWEEN "2013-11-12" AND "2014-01-12"
GROUP BY 1;