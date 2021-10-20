use mavenfuzzyfactory

SELECT 
	COUNT(DISTINCT(website_sessions.website_session_id)) AS sessions,
    count(orders.order_id) as orders,
	COUNT(DISTINCT(orders.order_id))/COUNT(DISTINCT(website_sessions.website_session_id)) AS conversion_rate
 FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < "2012-04-14" 
	AND website_sessions.utm_source= "gsearch" 
    AND website_sessions.utm_campaign= "nonbrand"
                    