SELECT 
	website_session_id,
    user_id,
    created_at
    
FROM website_sessions
WHERE created_at BETWEEN "2014-01-01" AND "2014-11-03"
AND is_repeat_session = 0;


CREATE TEMPORARY TABLE both_sessions
SELECT 
	first_session.user_id AS user_id,
    first_session.created_at AS first_visit,
    MIN(website_sessions.created_at) AS second_visit
FROM
(
SELECT 
	DISTINCT user_id,
	website_session_id,
    created_at
    
FROM website_sessions
WHERE created_at BETWEEN "2014-01-01" AND "2014-11-03"
AND is_repeat_session = 0) AS first_session
	LEFT JOIN website_sessions
		ON website_sessions.user_id = first_session.user_id
        AND website_sessions.is_repeat_session = 1
        AND website_sessions.created_at BETWEEN "2014-01-01" AND "2014-11-03"
        AND website_sessions.website_session_id > first_session.website_session_id
GROUP BY 1, 2;


SELECT 
 
    AVG(DATEDIFF(second_visit, first_visit)) AS avg_days_first_to_second,
    MIN(DATEDIFF(second_visit, first_visit)) AS min_days_first_to_second,
    MAX(DATEDIFF(second_visit, first_visit)) AS max_days_first_to_second


FROM both_sessions;






