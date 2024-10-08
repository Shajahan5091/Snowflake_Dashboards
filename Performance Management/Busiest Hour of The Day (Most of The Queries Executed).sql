ALTER SESSION SET TIMEZONE = UTC; 

SELECT  
    HOUR(START_TIME) AS HOUR, 
    COUNT(*) AS QUERY_COUNT 
FROM TABLE(SNOWFLAKE.INFORMATION_SCHEMA.QUERY_HISTORY()) 
WHERE  
    DATE(START_TIME) = CURRENT_DATE 
GROUP BY 
    HOUR 
ORDER BY 
    QUERY_COUNT DESC;