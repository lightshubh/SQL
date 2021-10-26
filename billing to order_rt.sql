-- finding the date when billing page was launched

SELECT
	pageview_url,
	MIN(DATE(created_at))
    
FROM website_pageviews
WHERE pageview_url IN ("/billing-2");

-- finding the concerned pages with session id
SELECT 
	website_pageviews.website_session_id,
    website_pageviews.pageview_url

FROM website_pageviews
	LEFT JOIN orders
		ON orders.website_session_id = website_pageviews.website_session_id
WHERE (website_pageviews.created_at BETWEEN "2012-09-10" AND "2012-11-10") AND (website_pageviews.pageview_url IN ("/billing", "/billing-2"));
      
      
      
-- by making the above query as subquery, calculating the rates:
      
SELECT 
	pageview_url,
	COUNT(DISTINCT session_id) AS sesssions,
    COUNT(DISTINCT session_order) AS orders,
    COUNT(DISTINCT session_order) / COUNT(DISTINCT session_id) AS billing_to_order_rt
FROM (SELECT 
	website_pageviews.website_session_id AS session_id,
    website_pageviews.pageview_url AS pageview_url,
    orders.website_session_id AS session_order

FROM website_pageviews
	LEFT JOIN orders
		ON orders.website_session_id = website_pageviews.website_session_id
WHERE (website_pageviews.created_at BETWEEN "2012-09-10" AND "2012-11-10") 
      AND (website_pageviews.pageview_url IN ("/billing", "/billing-2"))) AS concerned_pages
GROUP BY pageview_url;