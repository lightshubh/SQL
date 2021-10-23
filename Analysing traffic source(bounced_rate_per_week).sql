CREATE TEMPORARY TABLE min_pge_id_w_total_count
SELECT 
	website_sessions.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS first_page_id,
    COUNT(DISTINCT website_pageviews.website_pageview_id) AS total_pages
    

FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at > "2012-06-01" 
	  AND website_sessions.created_at < "2012-08-31" 
      AND website_sessions.utm_source= "gsearch" 
      AND website_sessions.utm_campaign= "nonbrand"
GROUP BY website_sessions.website_session_id;



CREATE TEMPORARY TABLE session_w_counts_and_created_at
SELECT 
	min_pge_id_w_total_count.website_session_id,
	min_pge_id_w_total_count.first_page_id,
	min_pge_id_w_total_count.total_pages,
	website_pageviews.created_at,
	website_pageviews.pageview_url

FROM min_pge_id_w_total_count
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = min_pge_id_w_total_count.first_page_id;
        
        
SELECT  
	MIN(DATE(created_at)) AS start_date,
    (COUNT(DISTINCT CASE WHEN total_pages = 1 THEN website_session_id ELSE NULL END)) / (COUNT(DISTINCT	website_session_id)) AS bounce_rate,
    COUNT(DISTINCT CASE WHEN pageview_url = "/home" THEN website_session_id ELSE NULL END) AS home_sessions,
    COUNT(DISTINCT CASE WHEN pageview_url = "/lander-1" THEN website_session_id ELSE NULL END) AS lander_sessions


FROM session_w_counts_and_created_at
GROUP BY WEEK(created_at);       
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        