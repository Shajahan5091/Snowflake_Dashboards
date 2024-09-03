SELECT 
    QUERY_TYPE, 
    WAREHOUSE_SIZE, 
    AVG(EXECUTION_TIME) / 1000 AS AVERAGE_EXECUTION_TIME 
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY 
GROUP BY 
    QUERY_TYPE, 
    WAREHOUSE_SIZE 
ORDER BY 
    AVERAGE_EXECUTION_TIME DESC;