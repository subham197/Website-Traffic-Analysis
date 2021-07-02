USE mavenfuzzyfactory;

-- DATA ON WHERE THE BULK OF THE WEBSITE SESSIONS ARE COMING FROM, BREAKDOWN ON UTM SOURCE, CAMPAIGN, REFERRING DOMAIN

SELECT 
    utm_source,
    utm_campaign,
    http_referer,
    COUNT(DISTINCT website_session_id) AS sessions
FROM
    website_sessions
WHERE
    created_at < '2012-04-12' 
GROUP BY utm_source , utm_campaign , http_referer
ORDER BY sessions DESC;

-- GSEARCH NONBRAND SESSION TO ORDER CONVERSION RATE
 
SELECT 
    COUNT(DISTINCT w.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.order_id) / COUNT(DISTINCT w.website_session_id) AS session_conversion_rate
FROM
    website_sessions w
        LEFT JOIN
    orders o ON w.website_session_id = o.website_session_id
WHERE
	utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
    AND w.created_at < '2012-04-14';

-- GSEARCH NONBRAND RESPONSE TO BID CHANGES

SELECT 
	MIN(DATE((created_at))) AS week_start_date,
	COUNT(DISTINCT website_session_id) AS sessions
FROM 
	website_sessions
WHERE utm_source='gsearch' 
	AND utm_campaign= 'nonbrand' 
	AND created_at < '2012-05-10'
GROUP BY YEAR(created_at), WEEK(created_at);


-- CONVERSION BASED ON DEVICE TYPE
SELECT 
		device_type,
        COUNT(DISTINCT w.website_session_id) AS sessions,
        COUNT(DISTINCT o.order_id) AS orders,
        COUNT(DISTINCT o.order_id)/COUNT(DISTINCT w.website_session_id) AS conversion_rate
FROM 
	website_sessions w
LEFT JOIN 
	orders o ON o.website_session_id=w.website_session_id
WHERE w.created_at < '2012-05-11' AND utm_source= 'gsearch' AND utm_campaign= 'nonbrand'
GROUP BY device_type;

-- DATA ON GSEARCH NONBRAND DESKTOP RESPONSE TO BID CHANGES

SELECT 
	MIN(DATE(created_at)) AS week_start_date,
	COUNT(CASE WHEN device_type='desktop' THEN website_session_id ELSE NULL END) AS desktop_sessions,
    COUNT(CASE WHEN device_type='mobile' THEN website_session_id ELSE NULL END) AS mobile_sessions
FROM website_sessions 
WHERE created_at BETWEEN '2012-04-15' AND '2012-06-09' 
				 AND utm_source= 'gsearch' 
                 AND utm_campaign= 'nonbrand'
GROUP BY 
		YEAR(created_at),
		WEEK(created_at);
