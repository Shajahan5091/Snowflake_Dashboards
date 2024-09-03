SELECT FIRST_AUTHENTICATION_FACTOR || ' ' ||NVL(SECOND_AUTHENTICATION_FACTOR, '') AS AUTHENTICATION_METHOD
    ,USER_NAME
    ,COUNT(*) AS COUNT
FROM SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY 
WHERE IS_SUCCESS = 'YES' 
    AND USER_NAME != 'WORKSHEETS_APP_USER' 
GROUP BY AUTHENTICATION_METHOD
    ,USER_NAME
ORDER BY COUNT DESC; 
