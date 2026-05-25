-- Financial Market Pricing Analysis
-- SQL Analysis Queries
-- This file contains business-focused SQL queries for reviewing pricing data,
-- pricing exceptions, vendor performance, and asset class trends.

-- 1. View all pricing records
SELECT *
FROM market_pricing_data
LIMIT 20;


-- 2. Count total pricing records
SELECT 
    COUNT(*) AS total_records
FROM market_pricing_data;


-- 3. Count pricing records by pricing status
SELECT 
    pricing_status,
    COUNT(*) AS record_count
FROM market_pricing_data
GROUP BY pricing_status
ORDER BY record_count DESC;


-- 4. Identify all pricing exceptions
SELECT 
    pricing_date,
    ticker,
    security_name,
    asset_class,
    pricing_vendor,
    previous_close,
    current_price,
    daily_change_pct,
    exception_reason
FROM market_pricing_data
WHERE exception_flag = 'Yes'
ORDER BY pricing_date;


-- 5. Count exceptions by exception reason
SELECT 
    exception_reason,
    COUNT(*) AS exception_count
FROM market_pricing_data
WHERE exception_flag = 'Yes'
GROUP BY exception_reason
ORDER BY exception_count DESC;


-- 6. Exception count by asset class
SELECT 
    asset_class,
    COUNT(*) AS total_records,
    SUM(CASE WHEN exception_flag = 'Yes' THEN 1 ELSE 0 END) AS exception_count,
    ROUND(
        SUM(CASE WHEN exception_flag = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        2
    ) AS exception_rate_pct
FROM market_pricing_data
GROUP BY asset_class
ORDER BY exception_rate_pct DESC;


-- 7. Exception rate by pricing vendor
SELECT 
    pricing_vendor,
    COUNT(*) AS total_records,
    SUM(CASE WHEN exception_flag = 'Yes' THEN 1 ELSE 0 END) AS exception_count,
    ROUND(
        SUM(CASE WHEN exception_flag = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        2
    ) AS exception_rate_pct
FROM market_pricing_data
GROUP BY pricing_vendor
ORDER BY exception_rate_pct DESC;


-- 8. Largest daily price movements
SELECT 
    pricing_date,
    ticker,
    security_name,
    asset_class,
    pricing_vendor,
    previous_close,
    current_price,
    daily_change_pct,
    exception_reason
FROM market_pricing_data
WHERE daily_change_pct IS NOT NULL
ORDER BY ABS(daily_change_pct) DESC
LIMIT 10;


-- 9. Missing vendor prices
SELECT 
    pricing_date,
    ticker,
    security_name,
    asset_class,
    pricing_vendor,
    previous_close,
    current_price,
    exception_reason
FROM market_pricing_data
WHERE exception_reason = 'Missing vendor price';


-- 10. Possible stale prices
SELECT 
    pricing_date,
    ticker,
    security_name,
    asset_class,
    pricing_vendor,
    previous_close,
    current_price,
    daily_change_pct,
    exception_reason
FROM market_pricing_data
WHERE exception_reason = 'Possible stale price';


-- 11. Average daily price movement by asset class
SELECT 
    asset_class,
    ROUND(AVG(daily_change_pct), 2) AS avg_daily_change_pct,
    ROUND(MAX(daily_change_pct), 2) AS max_daily_change_pct,
    ROUND(MIN(daily_change_pct), 2) AS min_daily_change_pct
FROM market_pricing_data
WHERE daily_change_pct IS NOT NULL
GROUP BY asset_class
ORDER BY avg_daily_change_pct DESC;


-- 12. Daily exception trend
SELECT 
    pricing_date,
    COUNT(*) AS total_records,
    SUM(CASE WHEN exception_flag = 'Yes' THEN 1 ELSE 0 END) AS exception_count
FROM market_pricing_data
GROUP BY pricing_date
ORDER BY pricing_date;


-- 13. Securities with the highest number of exceptions
SELECT 
    ticker,
    security_name,
    asset_class,
    COUNT(*) AS exception_count
FROM market_pricing_data
WHERE exception_flag = 'Yes'
GROUP BY ticker, security_name, asset_class
ORDER BY exception_count DESC;


-- 14. Business summary query
SELECT 
    COUNT(*) AS total_pricing_records,
    SUM(CASE WHEN exception_flag = 'Yes' THEN 1 ELSE 0 END) AS total_exceptions,
    ROUND(
        SUM(CASE WHEN exception_flag = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        2
    ) AS overall_exception_rate_pct
FROM market_pricing_data;
