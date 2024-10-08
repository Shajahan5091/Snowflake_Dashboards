SELECT L.USER_NAME
    ,FIRST_AUTHENTICATION_FACTOR
    ,SECOND_AUTHENTICATION_FACTOR
    ,COUNT(*) AS NUM_OF_EVENTS 
FROM SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY AS L 
JOIN SNOWFLAKE.ACCOUNT_USAGE.USERS U 
    ON L.USER_NAME = U.NAME AND L.USER_NAME ILIKE '%SVC' AND HAS_RSA_PUBLIC_KEY = 'TRUE' 
WHERE IS_SUCCESS = 'YES' 
    AND FIRST_AUTHENTICATION_FACTOR != 'RSA_KEYPAIR' 
GROUP BY L.USER_NAME
    ,FIRST_AUTHENTICATION_FACTOR
    ,SECOND_AUTHENTICATION_FACTOR 
ORDER BY NUM_OF_EVENTS DESC;