SELECT U.NAME
    ,TIMEDIFF(DAYS, LAST_SUCCESS_LOGIN, CURRENT_TIMESTAMP()) || ' days ago' AS LAST_LOGIN
    ,TIMEDIFF(DAYS, PASSWORD_LAST_SET_TIME,CURRENT_TIMESTAMP(6)) || ' days ago' AS PASSWORD_AGE 
FROM SNOWFLAKE.ACCOUNT_USAGE.USERS U 
JOIN SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_USERS G
    ON GRANTEE_NAME = NAME AND ROLE = 'ACCOUNTADMIN' AND G.DELETED_ON IS NULL 
WHERE EXT_AUTHN_DUO = FALSE 
    AND U.DELETED_ON IS NULL 
    AND HAS_PASSWORD = TRUE 
ORDER BY LAST_SUCCESS_LOGIN DESC; 