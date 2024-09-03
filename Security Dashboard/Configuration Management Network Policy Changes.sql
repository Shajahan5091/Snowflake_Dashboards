SELECT user_name || ' made the following Network Policy change on ' || end_time || ' [' ||  query_text || ']' AS Events 
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY 
WHERE EXECUTION_STATUS = 'SUCCESS' 
    AND QUERY_TYPE IN ('CREATE_NETWORK_POLICY', 'ALTER_NETWORK_POLICY', 'DROP_NETWORK_POLICY') 
    OR (query_text ilike '% set network_policy%' or query_text ilike '% unset network_policy%')
    AND QUERY_TYPE != 'SELECT' 
    AND QUERY_TYPE != 'UNKNOWN' 
ORDER BY END_TIME DESC;