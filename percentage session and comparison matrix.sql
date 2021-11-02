
-- 1 -- website session for utm source gsearch and bsearch between date '2012-08-22' and '2012-11-29' 

SELECT 
	MIN(DATE(created_at)) AS week_start_date,
    COUNT(DISTINCT website_session_id) AS total_session,
    COUNT(DISTINCT CASE WHEN utm_source= 'gsearch' THEN website_session_id ELSE NULL END) AS gsearch_session,
    COUNT(DISTINCT CASE WHEN utm_source= 'bsearch' THEN website_session_id ELSE NULL END) AS bsearch_session

FROM website_sessions
	WHERE created_at >= '2012-08-22'
          AND created_at < '2012-11-29'
          AND utm_campaign= 'nonbrand'
GROUP BY WEEK(created_at);

-- calculating percentage mobile session:
SELECT
	
    utm_source,
    COUNT(DISTINCT website_session_id) AS sessions,
	COUNT(DISTINCT CASE WHEN device_type= 'mobile' THEN website_session_id ELSE NULL END) AS mobile_sessions,
    COUNT(DISTINCT CASE WHEN device_type= 'mobile' THEN website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id) AS pct_mobile
 
FROM website_sessions
WHERE created_at >= '2012-08-22'
	  AND created_at < '2012-11-30'
      AND utm_source IN ('gsearch', 'bsearch')
      AND utm_campaign= 'nonbrand'
GROUP BY utm_source;

-- 3 -- desktop and mobile conversion rate according to utm_source

SELECT 
	website_sessions.device_type AS device_type,
    website_sessions.utm_source AS utm_source,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS conv_rt
	
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at >= "2012-08-22"
	  AND website_sessions.created_at < "2012-09-18"
      AND website_sessions.utm_campaign= "nonbrand"
GROUP BY 1,2;

-- 4 -- comparison matrix:

SELECT 
	MIN(DATE (created_at)) AS week_start_date, 
    COUNT(DISTINCT CASE WHEN utm_source= "gsearch" AND device_type= "desktop" THEN website_session_id ELSE NULL END) AS g_dtop_session,
    COUNT(DISTINCT CASE WHEN utm_source= "bsearch" AND device_type= "desktop" THEN website_session_id ELSE NULL END) AS b_dtop_session,
    COUNT(DISTINCT CASE WHEN utm_source= "bsearch" AND device_type= "desktop" THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN utm_source= "gsearch" AND device_type= "desktop" THEN website_session_id ELSE NULL END) AS b_pct_g_d,
    COUNT(DISTINCT CASE WHEN utm_source= "gsearch" AND device_type= "mobile" THEN website_session_id ELSE NULL END) AS g_mob_session,
    COUNT(DISTINCT CASE WHEN utm_source= "bsearch" AND device_type= "mobile" THEN website_session_id ELSE NULL END) AS b_mob_session,
    COUNT(DISTINCT CASE WHEN utm_source= "bsearch" AND device_type= "mobile" THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN utm_source= "gsearch" AND device_type= "mobile" THEN website_session_id ELSE NULL END) AS b_pct_g_m
    
FROM website_sessions
WHERE created_at >= "2012-11-04"
	  AND created_at < "2012-12-22"
      AND utm_campaign= "nonbrand"
GROUP BY WEEK(created_at);



















