USE mavenfuzzyfactory;

/* # we'll find the first pageview id for relevent session
# identify the landing page for each session
# counting pageviews for each session, to identify bounces
# summerising total session and bounce session */

# first landing page id
CREATE TEMPORARY TABLE first_page_id
SELECT 
	website_session_id,
    MIN(website_pageview_id) as landing_page

FROM website_pageviews
	WHERE created_at BETWEEN "2014-01-01" AND "2014-02-01"
GROUP BY website_session_id;

select * from first_page_id;

# first landing page url
CREATE TEMPORARY TABLE first_page_url
SELECT  
	first_page_id.website_session_id,
    website_pageviews.pageview_url AS landing_page_url

FROM first_page_id
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = first_page_id.landing_page;
        
SELECT * FROM first_page_url;        

# counting the number of pages per session id:
CREATE TEMPORARY TABLE total_number_of_pages
SELECT
	website_session_id,
    COUNT(website_pageview_id) as total_numbers_of_pages

FROM website_pageviews
	WHERE created_at BETWEEN "2014-01-01" AND "2014-02-01"
GROUP BY website_session_id; 

SELECT * FROM total_number_of_pages;

# bounce sessions:
CREATE TEMPORARY TABLE bounce_sessions
SELECT 
	website_session_id,
    total_numbers_of_pages

FROM total_number_of_pages_perSession
	WHERE total_numbers_of_pages = 1;



SELECT
	total_number_of_pages.website_session_id,
	total_number_of_pages.total_numbers_of_pages

FROM total_number_of_pages
	LEFT JOIN bounce_sessions
		ON bounce_sessions.website_session_id = total_number_of_pages.website_session_id;














