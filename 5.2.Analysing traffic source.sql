CREATE TEMPORARY TABLE temp_view
SELECT
	website_session_id,
	MIN(website_pageview_id) AS min_pgv
    
FROM website_pageviews
WHERE created_at < "2012-06-12"
GROUP BY website_session_id;

SELECT
	website_pageviews.pageview_url AS lending_page,
    COUNT(DISTINCT temp_view.website_session_id)
    
FROM temp_view
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = temp_view.min_pgv
GROUP BY lending_page;

