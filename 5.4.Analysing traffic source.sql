USE mavenfuzzyfactory;

/* # we'll find the first pageview id for relevent session
# identify the landing page for each session
# counting pageviews for each session, to identify bounces
# summerising total session and bounce session */

# 1
CREATE TEMPORARY TABLE first_pageviews_demo
SELECT 
	website_pageviews.website_session_id,
    MIN(DISTINCT website_pageviews.website_pageview_id) AS min_pageview_id

FROM website_pageviews
	INNER JOIN website_sessions
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.created_at BETWEEN "2014-01-01" AND "2014-02-01"
GROUP BY website_pageviews.website_session_id;

-- 2
CREATE TEMPORARY TABLE sessions_w_temporary_pagedemo
select 
	first_pageviews_demo.website_session_id,
    website_pageviews.pageview_url AS lending_page

from first_pageviews_demo
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = first_pageviews_demo.min_pageview_id;
       
-- 3 

CREATE TEMPORARY TABLE bounced_sessions_only
SELECT 
	sessions_w_temporary_pagedemo.website_session_id,
    sessions_w_temporary_pagedemo.lending_page,
    COUNT(DISTINCT(website_pageviews.website_pageview_id)) AS count_of_pages_viewed
    
FROM sessions_w_temporary_pagedemo 
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = sessions_w_temporary_pagedemo.website_session_id
GROUP BY  sessions_w_temporary_pagedemo.website_session_id,
          sessions_w_temporary_pagedemo.lending_page
HAVING count_of_pages_viewed = 1;    

-- 4

SELECT 
	sessions_w_temporary_pagedemo.lending_page,
	COUNT(sessions_w_temporary_pagedemo.website_session_id) AS sessions,
	COUNT(DISTINCT bounced_sessions_only.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT bounced_sessions_only.website_session_id) / COUNT(sessions_w_temporary_pagedemo.website_session_id) AS bounced_rate

FROM sessions_w_temporary_pagedemo
	LEFT JOIN bounced_sessions_only
		ON sessions_w_temporary_pagedemo.website_session_id = bounced_sessions_only.website_session_id
GROUP BY sessions_w_temporary_pagedemo.lending_page
ORDER BY bounced_rate DESC;

        
        
        
        
        
        
        
        