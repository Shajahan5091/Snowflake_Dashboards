SELECT 
    USER_NAME, 
    AVG(EXECUTION_TIME) / 1000 AS AVERAGE_EXECUTION_TIME 
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY 
GROUP BY 
    USER_NAME    	 
ORDER BY 
    AVERAGE_EXECUTION_TIME DESC;