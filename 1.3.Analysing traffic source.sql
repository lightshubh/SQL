use mavenfuzzyfactory;

SELECT
	MONTH(created_at),
    WEEK(created_at),
    MIN(DATE(created_at)) AS day,
    COUNT(DISTINCT(website_session_id)) AS total_session
FROM website_sessions
WHERE website_session_id BETWEEN 100000 AND 115000  
GROUP BY MONTH(created_at),
         WEEK(created_at)
ORDER BY total_session DESC         
      
         
	