USE mavenfuzzyfactory;

select * from website_pageviews;
select * from website_sessions;

-- 1 creating the concerned table

CREATE TEMPORARY TABLE concerned_table
select 
	website_pageviews.website_pageview_id,
    website_pageviews.created_at,
    website_pageviews.website_session_id,
    website_pageviews.pageview_url,
    website_sessions.device_type

from website_pageviews
	INNER JOIN website_sessions
		ON website_sessions.website_session_id = website_pageviews.website_session_id
Where website_pageviews.pageview_url IN ("/home", "/lander-1")
	AND (website_sessions.utm_source = "gsearch" And website_sessions.utm_campaign = "nonbrand")
    And (website_pageviews.created_at BETWEEN "2012-06-19" AND "2012-07-28");
    
    
    
    -- 2 finding the 
 
CREATE TEMPORARY TABLE bounced_session 
SELECT 
	concerned_table.website_session_id,
    concerned_table.pageview_url,
    COUNT(DISTINCT concerned_table.website_pageview_id) AS bounced_sessison
	

 FROM concerned_table
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = concerned_table.website_pageview_id
 GROUP BY concerned_table.website_session_id
 HAVING bounced_sessison = 1;
 
 -- 3 total sessions
 
 CREATE TEMPORARY TABLE total_sessions
 SELECT 
	bounced_session.pageview_url,
    COUNT(DISTINCT concerned_table.website_pageview_id) AS total_session,
    COUNT(DISTINCT bounced_session.website_session_id) AS total_bounced
 
 FROM bounced_session
	LEFT JOIN concerned_table 
		ON concerned_table.website_session_id = bounced_session.website_session_id
GROUP BY bounced_session.pageview_url; 

SELECT 
	pageview_url,
    total_session,
    total_bounced,
    (total_bounced / total_session) AS bounced_rate

FROM total_sessions;       
    
    
    
    
    
    
    
    
    
    