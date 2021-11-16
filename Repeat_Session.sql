SELECT 
	user_id,
    website_session_id
FROM website_sessions
WHERE created_at BETWEEN "2014-01-01" AND "2014-11-01"
	  AND is_repeat_session = 0;
      
      
-- -------------------------------------------------------------------------------------------
CREATE TEMPORARY TABLE sessions_with_repeat
SELECT 
	first_session.user_id,
    first_session.website_session_id AS first_session,
    website_sessions.website_session_id AS repeat_session
FROM
(
SELECT 
	user_id,
    website_session_id
FROM website_sessions
WHERE created_at BETWEEN "2014-01-01" AND "2014-11-01"
	  AND is_repeat_session = 0
) AS first_session
	LEFT JOIN website_sessions
		ON website_sessions.user_id = first_session.user_id
        AND website_sessions.website_session_id > first_session.website_session_id 
        AND website_sessions.created_at BETWEEN "2014-01-01" AND "2014-11-01";
        -- drop temporary table sessions_with_repeat;
SELECT 
	repeat_session,
    COUNT(DISTINCT user_id) AS user_id
FROM
(        
SELECT 
	user_id,
    COUNT(DISTINCT first_session) AS first_session,
    COUNT(repeat_session) AS repeat_session
FROM sessions_with_repeat
GROUP BY 1
) AS concerned_table
GROUP BY 1;        