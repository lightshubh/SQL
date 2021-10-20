USE mavenfuzzyfactory;

CREATE TEMPORARY TABLE first_view
SELECT 
    website_session_id,
    MIN(website_pageview_id) AS min_pgv_details

FROM website_pageviews
WHERE website_pageview_id < 1000
GROUP BY website_session_id;


SELECT 
	website_pageviews.pageview_url,
    COUNT(first_view.min_pgv_details) AS toal_visit

FROM first_view
	LEFT JOIN website_pageviews
		ON first_view.min_pgv_details = website_pageviews.website_pageview_id
	GROUP BY 1
    ORDER BY toal_visit DESC;
    
