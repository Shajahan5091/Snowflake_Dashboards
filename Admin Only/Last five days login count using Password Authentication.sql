ALTER SESSION SET TIMEZONE = UTC; 

SELECT DATE(EVENT_TIMESTAMP) AS DATE
    ,COUNT(*) AS PASSWORD  
FROM TABLE(SNOWFLAKE.INFORMATION_SCHEMA.LOGIN_HISTORY())  
WHERE DATE > DATEADD(DAY, -5, CURRENT_DATE) 
    AND FIRST_AUTHENTICATION_FACTOR = 'PASSWORD'  
GROUP BY  
    DATE;  