SELECT
	utm_source,
    utm_campaign,
    http_referer,
    COUNT(DISTINCT(website_session_id)) AS total_session
FROM website_sessions
Where created_at < "2012-04-12"
GROUP BY utm_source,
         utm_campaign,
         http_referer
ORDER BY total_session DESC


