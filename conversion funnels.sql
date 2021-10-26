USE mavenfuzzyfactory;

SELECT
	website_sessions.website_session_id, 
    -- website_pageviews.pageview_url,
    MAX(CASE WHEN website_pageviews.pageview_url= "/lander-1" THEN 1 ELSE 0 END) AS lander_page,
	MAX(CASE WHEN website_pageviews.pageview_url= "/products" THEN 1 ELSE 0 END) AS products,
    MAX(CASE WHEN website_pageviews.pageview_url= "/the-original-mr-fuzzy" THEN 1 ELSE 0 END) AS original_mr_fuzzy,
    MAX(CASE WHEN website_pageviews.pageview_url= "/cart" THEN 1 ELSE 0 END) AS cart,
    MAX(CASE WHEN website_pageviews.pageview_url= "/shipping" THEN 1 ELSE 0 END) AS shipping,
    MAX(CASE WHEN website_pageviews.pageview_url= "/billing" THEN 1 ELSE 0 END) AS billing,
    MAX(CASE WHEN website_pageviews.pageview_url= "/thank-you-for-your-order" THEN 1 ELSE 0 END) AS thank_you_page

FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at >= "2012-08-05"
	  AND website_sessions.created_at < "2012-09-05"
      AND website_sessions.utm_source= "gsearch"
      AND website_sessions.utm_campaign= "nonbrand"
GROUP BY website_sessions.website_session_id;


SELECT  
	COUNT(DISTINCT website_session_id) AS total_users,
    COUNT(DISTINCT CASE WHEN lander_page= 1 THEN website_session_id ELSE NULL END) AS total_lander,
    COUNT(DISTINCT CASE WHEN products= 1 THEN website_session_id ELSE NULL END) AS total_products,
    COUNT(DISTINCT CASE WHEN original_mr_fuzzy= 1 THEN website_session_id ELSE NULL END) AS total_original_mrfuzzy,
    COUNT(DISTINCT CASE WHEN cart= 1 THEN website_session_id ELSE NULL END) AS total_cart,
    COUNT(DISTINCT CASE WHEN shipping= 1 THEN website_session_id ELSE NULL END) AS total_shipping,
    COUNT(DISTINCT CASE WHEN billing= 1 THEN website_session_id ELSE NULL END) AS total_billing,
    COUNT(DISTINCT CASE WHEN thank_you_page= 1 THEN website_session_id ELSE NULL END) AS total_thank_page




FROM (SELECT
	website_sessions.website_session_id, 
    -- website_pageviews.pageview_url,
    MAX(CASE WHEN website_pageviews.pageview_url= "/lander-1" THEN 1 ELSE 0 END) AS lander_page,
	MAX(CASE WHEN website_pageviews.pageview_url= "/products" THEN 1 ELSE 0 END) AS products,
    MAX(CASE WHEN website_pageviews.pageview_url= "/the-original-mr-fuzzy" THEN 1 ELSE 0 END) AS original_mr_fuzzy,
    MAX(CASE WHEN website_pageviews.pageview_url= "/cart" THEN 1 ELSE 0 END) AS cart,
    MAX(CASE WHEN website_pageviews.pageview_url= "/shipping" THEN 1 ELSE 0 END) AS shipping,
    MAX(CASE WHEN website_pageviews.pageview_url= "/billing" THEN 1 ELSE 0 END) AS billing,
    MAX(CASE WHEN website_pageviews.pageview_url= "/thank-you-for-your-order" THEN 1 ELSE 0 END) AS thank_you_page

FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at BETWEEN "2012-08-05" AND "2012-09-05"
      AND website_sessions.utm_source= "gsearch"
      AND website_sessions.utm_campaign= "nonbrand"
GROUP BY website_sessions.website_session_id) AS pages_proceding;

-- click through rate:

SELECT  
	COUNT(DISTINCT website_session_id) AS total_users,
    COUNT(DISTINCT CASE WHEN lander_page= 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id) AS to_total_lander,
    COUNT(DISTINCT CASE WHEN products= 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id) AS to_total_products,
    COUNT(DISTINCT CASE WHEN original_mr_fuzzy= 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id) AS to_total_original_mrfuzzy,
    COUNT(DISTINCT CASE WHEN cart= 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id) AS to_total_cart,
    COUNT(DISTINCT CASE WHEN shipping= 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id) AS to_total_shipping,
    COUNT(DISTINCT CASE WHEN billing= 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id) AS to_total_billing,
    COUNT(DISTINCT CASE WHEN thank_you_page= 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id) AS to_total_thank_page




FROM (SELECT
	website_sessions.website_session_id, 
    -- website_pageviews.pageview_url,
    MAX(CASE WHEN website_pageviews.pageview_url= "/lander-1" THEN 1 ELSE 0 END) AS lander_page,
	MAX(CASE WHEN website_pageviews.pageview_url= "/products" THEN 1 ELSE 0 END) AS products,
    MAX(CASE WHEN website_pageviews.pageview_url= "/the-original-mr-fuzzy" THEN 1 ELSE 0 END) AS original_mr_fuzzy,
    MAX(CASE WHEN website_pageviews.pageview_url= "/cart" THEN 1 ELSE 0 END) AS cart,
    MAX(CASE WHEN website_pageviews.pageview_url= "/shipping" THEN 1 ELSE 0 END) AS shipping,
    MAX(CASE WHEN website_pageviews.pageview_url= "/billing" THEN 1 ELSE 0 END) AS billing,
    MAX(CASE WHEN website_pageviews.pageview_url= "/thank-you-for-your-order" THEN 1 ELSE 0 END) AS thank_you_page

FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at BETWEEN "2012-08-05" AND "2012-09-05"
      AND website_sessions.utm_source= "gsearch"
      AND website_sessions.utm_campaign= "nonbrand"
GROUP BY website_sessions.website_session_id) AS pages_proceding;










