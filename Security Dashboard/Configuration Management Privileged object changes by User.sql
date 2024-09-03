SELECT QUERY_TEXT 
    ,USER_NAME
    ,ROLE_NAME
    ,END_TIME 
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY 
WHERE EXECUTION_STATUS = 'SUCCESS' 
    AND QUERY_TYPE NOT IN ('SELECT') 
    AND (QUERY_TEXT ILIKE '%create role%' 
    OR QUERY_TEXT ILIKE '%manage grants%' 
    OR QUERY_TEXT ILIKE '%create integration%' 
    OR QUERY_TEXT ILIKE '%create share%' 
    OR QUERY_TEXT ILIKE '%create account%' 
    OR QUERY_TEXT ILIKE '%monitor usage%' 
    OR QUERY_TEXT ILIKE '%ownership%' 
    OR QUERY_TEXT ILIKE '%drop table%' 
    OR QUERY_TEXT ILIKE '%drop database%' 
    OR QUERY_TEXT ILIKE '%create stage%' 
    OR QUERY_TEXT ILIKE '%drop stage%' 
    OR QUERY_TEXT ILIKE '%alter stage%' 
    ) 
ORDER BY END_TIME DESC; 