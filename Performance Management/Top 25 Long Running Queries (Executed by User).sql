SELECT 
    QUERY_ID, 
    QUERY_TEXT, 
    (EXECUTION_TIME / 60000) AS EXEC_TIME 
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY 
WHERE 
    IS_CLIENT_GENERATED_STATEMENT = 'FALSE' 
ORDER BY 
    EXECUTION_TIME DESC 
LIMIT 
    25;