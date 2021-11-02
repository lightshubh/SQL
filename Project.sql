-- 1 -- monthly 'gsearch trend

SELECT 
    MONTH(website_sessions.created_at) AS months,
    YEAR(website_sessions.created_at) AS yr,
    COUNT( DISTINCT website_sessions.website_session_id) AS total_customers,
    COUNT(orders.order_id) as total_order

FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.utm_source= 'gsearch'
	  AND website_sessions.created_at < '2012-11-27'
GROUP BY 1, 2;


-- 2 -- monthly trend by splitting out non-brand and brand campaign

SELECT 
	YEAR(website_sessions.created_at) AS yr,
    MONTH(website_sessions.created_at) AS mon,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_campaign = 'nonbrand' THEN website_sessions.website_session_id ELSE NULL END) AS non_brand_sessions,
    COUNT( DISTINCT CASE WHEN website_sessions.utm_campaign= 'nonbrand' THEN orders.order_id ELSE NULL END) AS total_nonbrand_orders,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_campaign = 'brand' THEN website_sessions.website_session_id ELSE NULL END) AS brand_sessions,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_campaign= 'brand' THEN orders.order_id ELSE NULL END) AS total_brand_orders
--	COUNT( DISTINCT website_sessions.website_session_id) AS total_sessions,
--    COUNT(orders.order_id) AS total_orders

FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < "2012-11-27"
	  AND website_sessions.utm_source= "gsearch"
GROUP BY 1,2;

-- 3 -- monthly session according to device type:

SELECT 
	YEAR(website_sessions.created_at) AS yr,
    MONTH(website_sessions.created_at) AS mon,
    COUNT( DISTINCT CASE WHEN website_sessions.device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) AS mobile_sessions,
    COUNT( DISTINCT CASE WHEN website_sessions.device_type = 'mobile' THEN orders.order_id ELSE NULL END) AS m_order_count,
    (COUNT( DISTINCT CASE WHEN website_sessions.device_type = 'mobile' THEN orders.order_id ELSE NULL END)) / (COUNT( DISTINCT CASE WHEN website_sessions.device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END)) AS m_conv_rt,
    COUNT( DISTINCT CASE WHEN website_sessions.device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END) AS desktop_sessions,
    COUNT( DISTINCT CASE WHEN website_sessions.device_type = 'desktop' THEN orders.order_id ELSE NULL END) AS d_order_count,
	(COUNT( DISTINCT CASE WHEN website_sessions.device_type = 'desktop' THEN orders.order_id ELSE NULL END)) / (COUNT( DISTINCT CASE WHEN website_sessions.device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END)) AS d_conv_rt
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < "2012-11-27"
	  AND website_sessions.utm_source= "gsearch"
      AND website_sessions.utm_campaign= "nonbrand"
GROUP BY 1,2;

-- 4 --

SELECT 
	YEAR(website_sessions.created_at) AS yr,
    MONTH(website_sessions.created_at) AS mon,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_source= "gsearch" THEN website_sessions.website_session_id ELSE NULL END) AS gsearch_sessions,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_source= "gsearch" THEN orders.order_id ELSE NULL END) AS gsearch_orders,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_source= "bsearch" THEN website_sessions.website_session_id ELSE NULL END) AS bsearch_sessions,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_source= "bsearch" THEN orders.order_id ELSE NULL END) AS bsearch_orders,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_source= "socialbook" THEN website_sessions.website_session_id ELSE NULL END) AS socialbook_sessions,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_source= "socialbook" THEN orders.order_id ELSE NULL END) AS socialbook_orders
    
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id 
WHERE website_sessions.created_at < "2012-11-27"
GROUP BY 1, 2;


-- 

SELECT 
	YEAR(website_sessions.created_at) AS yr,
    MONTH(website_sessions.created_at) AS mon,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_source= "gsearch" THEN website_sessions.website_session_id ELSE NULL END) AS gsearch_sessions,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_source= "bsearch" THEN website_sessions.website_session_id ELSE NULL END) AS bsearch_sessions,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_source IS NULL AND website_sessions.http_referer IS NOT NULL THEN website_sessions.website_session_id ELSE NULL END) AS organic_traffic,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_source IS NULL AND website_sessions.http_referer IS NULL THEN website_sessions.website_session_id ELSE NULL END) AS direct_traffic
    
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id 
WHERE website_sessions.created_at < "2012-11-27"
GROUP BY 1, 2;


-- 5 -- session to order conversion rate

SELECT
	YEAR(website_sessions.created_at) AS yr,
	MONTH(website_sessions.created_at) AS mon,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS session_order_cov_rt

FROM website_sessions
		LEFT JOIN orders
			ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < "2012-11-27" 
GROUP BY 1, 2;           

-- 6 -- conv rate

SELECT 
	pageview_url,
    website_pageview_id,
    MIN(created_at)

FROM website_pageviews
WHERE pageview_url = '/lander-1';

            -- finding the min pageview for each session
CREATE TEMPORARY TABLE min_page_id
SELECT 
	website_sessions.website_session_id AS sessions,
    MIN(website_pageviews.website_pageview_id) AS first_page_id

FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = website_sessions.website_session_id
WHERE website_pageviews.website_pageview_id > 23504
	  AND website_sessions.created_at < "2012-07-28"
      AND website_sessions.utm_source= "gsearch"
      AND website_sessions.utm_campaign= "nonbrand"
GROUP BY 1;

			-- finding the first page of each session id
   
CREATE TEMPORARY TABLE first_page_demo
SELECT 
	min_page_id.sessions,
    website_pageviews.pageview_url as landing_page


FROM min_page_id
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = min_page_id.first_page_id
WHERE website_pageviews.pageview_url IN ("/home", "/lander-1"); 

             -- calculating the orders for these pages
CREATE TEMPORARY TABLE first_page_demo_w_Order_id
SELECT 
first_page_demo.sessions,
first_page_demo.landing_page,
orders.order_id AS order_id


FROM first_page_demo
	LEFT JOIN orders
		ON orders.website_session_id = first_page_demo.sessions;  
        
        
SELECT 
	landing_page,
    COUNT(DISTINCT sessions) as total_sessions,
    COUNT(DISTINCT order_id) as total_orders,
    COUNT(DISTINCT order_id) / COUNT(DISTINCT sessions) AS conv_rt
    
FROM first_page_demo_w_Order_id
GROUP BY landing_page;


                -- finding the most recent pageviews for gsearch non brand where traffic was send to home

SELECT 
	MAX(website_sessions.website_session_id)

FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < "2012-11-27"
	  AND website_pageviews.pageview_url = "/home"
      AND website_sessions.utm_source= "gsearch"
      AND website_sessions.utm_campaign= "nonbrand";

-- max website session= 17145

SELECT 
	COUNT(DISTINCT website_session_id) AS sessions_since_test

FROM website_sessions
	WHERE website_session_id > 17145
    AND utm_source= 'gsearch'
    AND utm_campaign= 'nonbrand'
    AND created_at < "2012-11-27";
    
-- total session since test   
-- conclusion, with   0.0406-0.0318= 0.0088 conv rate, the total cov rate since last home page appeared is 0.0088*22972= 202.1536
-- so almost 202.1536/4= 50.54 extra order per month



-- 7 --------------------------

SELECT 
	website_sessions.website_session_id AS session_id,
    website_pageviews.pageview_url AS pageview_url,
    website_sessions.created_at AS created_at,
    (CASE WHEN website_pageviews.pageview_url= '/home' THEN 1 ELSE 0 END) AS landing_page,
    (CASE WHEN website_pageviews.pageview_url= '/lander-1' THEN 1 ELSE 0 END) AS lander_1,
    (CASE WHEN website_pageviews.pageview_url= '/products' THEN 1 ELSE 0 END) AS products,
    (CASE WHEN website_pageviews.pageview_url= '/the-original-mr-fuzzy' THEN 1 ELSE 0 END) AS mr_fuzzy_page,
    (CASE WHEN website_pageviews.pageview_url= '/cart' THEN 1 ELSE 0 END) AS cart,
    (CASE WHEN website_pageviews.pageview_url= '/shipping' THEN 1 ELSE 0 END) AS shipping,
    (CASE WHEN website_pageviews.pageview_url= '/billing' THEN 1 ELSE 0 END) AS billing,
    (CASE WHEN website_pageviews.pageview_url= '/thank-you-for-your-order' THEN 1 ELSE 0 END) AS thank_you_page
    

FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at BETWEEN "2012-06-19" AND "2012-07-28"
	  AND website_sessions.utm_source= 'gsearch'
      AND website_sessions.utm_campaign= 'nonbrand';   

CREATE TEMPORARY TABLE concerned_table
SELECT
	session_id,
    MAX(landing_page) AS home_page,
    MAX(lander_1) AS lander_1,
    MAX(products) AS products,
    MAX(mr_fuzzy_page) AS mr_fuzzy_page,
    MAX(cart) AS cart,
    MAX(shipping) AS shipping,
    MAX(billing) AS billing,
    MAX(thank_you_page) AS thank_you_page
    
FROM(SELECT 
	website_sessions.website_session_id AS session_id,
    website_pageviews.pageview_url AS pageview_url,
    website_sessions.created_at AS created_at,
    (CASE WHEN website_pageviews.pageview_url= '/home' THEN 1 ELSE 0 END) AS landing_page,
    (CASE WHEN website_pageviews.pageview_url= '/lander-1' THEN 1 ELSE 0 END) AS lander_1,
    (CASE WHEN website_pageviews.pageview_url= '/products' THEN 1 ELSE 0 END) AS products,
    (CASE WHEN website_pageviews.pageview_url= '/the-original-mr-fuzzy' THEN 1 ELSE 0 END) AS mr_fuzzy_page,
    (CASE WHEN website_pageviews.pageview_url= '/cart' THEN 1 ELSE 0 END) AS cart,
    (CASE WHEN website_pageviews.pageview_url= '/shipping' THEN 1 ELSE 0 END) AS shipping,
    (CASE WHEN website_pageviews.pageview_url= '/billing' THEN 1 ELSE 0 END) AS billing,
    (CASE WHEN website_pageviews.pageview_url= '/thank-you-for-your-order' THEN 1 ELSE 0 END) AS thank_you_page
    

FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at BETWEEN "2012-06-19" AND "2012-07-28"
	  AND website_sessions.utm_source= 'gsearch'
      AND website_sessions.utm_campaign= 'nonbrand') AS concerned_table
GROUP BY session_id,
		created_at;  

-- home= ['/home', /products, /the-original-mr-fuzzy, /cart, /shipping, /billing, /thank-you-for-your-order ]
-- lander-1 = [/lander-1, /products, /the-original-mr-fuzzy, /cart, /shipping, /billing, /thank-you-for-your-order]

-- conversion:

SELECT 
	(CASE WHEN home_page= 1 THEN 'home_page'
          WHEN lander_1=1 THEN 'lander_page'
    ELSE NULL
    END) AS landing_page,
    
    COUNT(DISTINCT session_id) AS session_id,     
    COUNT(DISTINCT CASE WHEN products= 1 THEN session_id ELSE NULL END) AS product_page,
    COUNT(DISTINCT CASE WHEN mr_fuzzy_page= 1 THEN session_id ELSE NULL END) AS mr_fuzzy_page,
    COUNT(DISTINCT CASE WHEN cart= 1 THEN session_id ELSE NULL END) AS cart,
    COUNT(DISTINCT CASE WHEN shipping= 1 THEN session_id ELSE NULL END) AS shipping,
    COUNT(DISTINCT CASE WHEN billing= 1 THEN session_id ELSE NULL END) AS billing,
    COUNT(DISTINCT CASE WHEN thank_you_page= 1 THEN session_id ELSE NULL END) AS thank_you_page
    
 FROM concerned_table
 GROUP BY 1;
 
 -- conversion rate:
 
SELECT 
	(CASE WHEN home_page= 1 THEN 'home_page'
          WHEN lander_1=1 THEN 'lander_page'
    ELSE NULL
    END) AS landing_page,
    
    COUNT(DISTINCT session_id) AS session_id,     
    COUNT(DISTINCT CASE WHEN products= 1 THEN session_id ELSE NULL END) / COUNT(DISTINCT session_id) AS product_page_conv_rt,
    COUNT(DISTINCT CASE WHEN mr_fuzzy_page= 1 THEN session_id ELSE NULL END) / COUNT(DISTINCT session_id) AS mr_fuzzy_page_conv_rt,
    COUNT(DISTINCT CASE WHEN cart= 1 THEN session_id ELSE NULL END) / COUNT(DISTINCT session_id) AS cart_conv_rt,
    COUNT(DISTINCT CASE WHEN shipping= 1 THEN session_id ELSE NULL END) / COUNT(DISTINCT session_id) AS shipping_conv_rt,
    COUNT(DISTINCT CASE WHEN billing= 1 THEN session_id ELSE NULL END) / COUNT(DISTINCT session_id) AS billing_conv_rt,
    COUNT(DISTINCT CASE WHEN thank_you_page= 1 THEN session_id ELSE NULL END) / COUNT(DISTINCT session_id) AS thank_you_page_conv_rt
    
 FROM concerned_table
 GROUP BY 1;

-- click through rate:

SELECT 
	(CASE WHEN home_page= 1 THEN 'home_page'
          WHEN lander_1=1 THEN 'lander_page'
    ELSE NULL
    END) AS landing_page,
    
    COUNT(DISTINCT session_id) AS session_id,     
    COUNT(DISTINCT CASE WHEN products= 1 THEN session_id ELSE NULL END) / COUNT(DISTINCT session_id) AS lander_through_rt,
    COUNT(DISTINCT CASE WHEN mr_fuzzy_page= 1 THEN session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN products= 1 THEN session_id ELSE NULL END) AS product_click_rt,
    COUNT(DISTINCT CASE WHEN cart= 1 THEN session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN mr_fuzzy_page= 1 THEN session_id ELSE NULL END) AS mrfuzzy_click_rt,
    COUNT(DISTINCT CASE WHEN shipping= 1 THEN session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN cart= 1 THEN session_id ELSE NULL END)AS cart_click_rt,
    COUNT(DISTINCT CASE WHEN billing= 1 THEN session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN shipping= 1 THEN session_id ELSE NULL END)AS shipping_click_rt,
    COUNT(DISTINCT CASE WHEN thank_you_page= 1 THEN session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN billing= 1 THEN session_id ELSE NULL END) AS billing_click_rt
    
 FROM concerned_table
 GROUP BY 1;
 
 
 
SELECT 
	(CASE WHEN landing_page= 1 THEN 'home_page'
          WHEN lander_1= 1 THEN 'lander_page'
    ELSE NULL
    END) AS landing_page,
    COUNT(DISTINCT session_id) AS session_id,     
    COUNT(DISTINCT CASE WHEN products= 1 THEN session_id ELSE NULL END) AS product_page,
    COUNT(DISTINCT CASE WHEN mr_fuzzy_page= 1 THEN session_id ELSE NULL END) AS mr_fuzzy_page,
    COUNT(DISTINCT CASE WHEN cart= 1 THEN session_id ELSE NULL END) AS cart,
    COUNT(DISTINCT CASE WHEN shipping= 1 THEN session_id ELSE NULL END) AS shipping,
    COUNT(DISTINCT CASE WHEN billing= 1 THEN session_id ELSE NULL END) AS billing,
    COUNT(DISTINCT CASE WHEN thank_you_page= 1 THEN session_id ELSE NULL END) AS thank_you_page
    
 FROM (SELECT
	session_id,
    MAX(landing_page) AS home_page,
    MAX(lander_1) AS lander_1,
    MAX(products) AS products,
    MAX(mr_fuzzy_page) AS mr_fuzzy_page,
    MAX(cart) AS cart,
    MAX(shipping) AS shipping,
    MAX(billing) AS billing,
    MAX(thank_you_page) AS thank_you_page
    
FROM(SELECT 
	website_sessions.website_session_id AS session_id,
    website_pageviews.pageview_url AS pageview_url,
    website_sessions.created_at AS created_at,
    (CASE WHEN website_pageviews.pageview_url= '/home' THEN 1 ELSE 0 END) AS landing_page,
    (CASE WHEN website_pageviews.pageview_url= '/lander-1' THEN 1 ELSE 0 END) AS lander_1,
    (CASE WHEN website_pageviews.pageview_url= '/products' THEN 1 ELSE 0 END) AS products,
    (CASE WHEN website_pageviews.pageview_url= '/the-original-mr-fuzzy' THEN 1 ELSE 0 END) AS mr_fuzzy_page,
    (CASE WHEN website_pageviews.pageview_url= '/cart' THEN 1 ELSE 0 END) AS cart,
    (CASE WHEN website_pageviews.pageview_url= '/shipping' THEN 1 ELSE 0 END) AS shipping,
    (CASE WHEN website_pageviews.pageview_url= '/billing' THEN 1 ELSE 0 END) AS billing,
    (CASE WHEN website_pageviews.pageview_url= '/thank-you-for-your-order' THEN 1 ELSE 0 END) AS thank_you_page
    

FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at BETWEEN "2012-06-19" AND "2012-07-28"
	  AND website_sessions.utm_source= 'gsearch'
      AND website_sessions.utm_campaign= 'nonbrand') AS T_table_0
GROUP BY session_id,
		created_at) AS T_table1) AS T_table2
 GROUP BY 1;


-- 8 -- revenue per session
SELECT 
  -- website_sessions.website_session_id AS website_sessions,
	COUNT(DISTINCT website_sessions.website_session_id) AS total_sessions,
    COUNT(DISTINCT orders.order_id) AS total_orders,
    SUM(orders.order_id * orders.items_purchased) AS total_revenue,
    SUM(orders.order_id * orders.items_purchased) / COUNT(website_sessions.website_session_id) AS revenue_per_session
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at BETWEEN "2012-09-10" AND "2012-11-10"
	  AND website_sessions.utm_source= 'gsearch'
      AND website_sessions.utm_campaign= 'nonbrand'; 
      
-- 8.1 -- revenue per billing page:

SELECT
 
	website_pageviews.pageview_url AS billing_page_type,
    orders.order_id AS order_id,
    orders.items_purchased as item_purchased,
    orders.price_usd AS price_usd
    
FROM website_pageviews
	LEFT JOIN orders
		ON website_pageviews.website_session_id = orders.website_session_id
WHERE website_pageviews.created_at BETWEEN "2012-09-10"  AND "2012-11-10" 
	AND website_pageviews.pageview_url IN ('/billing', '/billing-2');

SELECT 
	billing_page_type,
    COUNT(DISTINCT website_sessions) as total_sessions,
    SUM(price_usd) as total_revenue,
    SUM(price_usd) / COUNT(DISTINCT website_sessions) AS revenue_per_billing_page
FROM (SELECT
	website_pageviews.website_session_id AS website_sessions,
	website_pageviews.pageview_url AS billing_page_type,
    orders.price_usd AS price_usd
    
FROM website_pageviews
	LEFT JOIN orders
		ON website_pageviews.website_session_id = orders.website_session_id
WHERE website_pageviews.created_at BETWEEN "2012-09-10"  AND "2012-11-10" 
	AND website_pageviews.pageview_url IN ('/billing', '/billing-2')) AS concerned_table
GROUP BY billing_page_type;
    
-- 22.83 (/billing), 31.34 (/billing-2)
-- lift= 8.51

-- finding max /billing page

SELECT 
	pageview_url,
	MAX(created_at), 
    MAX(website_pageview_id) 
FROM website_pageviews
WHERE pageview_url= '/billing'
	  AND created_at BETWEEN "2012-09-10"  AND "2012-11-10";

SELECT 
	COUNT(pageview_url) AS total_billing_2_after_last_billing
FROM website_pageviews
WHERE pageview_url IN ('/billing', '/billing-2')
      AND created_at BETWEEN '2012-10-27' AND '2012-11-27';
 --  hence total increase 1193*8.51= 10,152.43
    
    
         
