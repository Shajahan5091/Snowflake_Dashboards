WITH ROLE_HIER AS ( 
    --Extract all Roles 
    SELECT GRANTEE_NAME
        ,NAME
    FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES 
    WHERE GRANTED_ON = 'ROLE' AND PRIVILEGE = 'USAGE' AND DELETED_ON IS NULL 
    UNION ALL 
        --Adding in dummy records for "root" roles 
    SELECT 'root'
        ,r.NAME 
    FROM SNOWFLAKE.ACCOUNT_USAGE.ROLES AS r 
    WHERE DELETED_ON IS NULL 
        AND NOT EXISTS ( 
                SELECT 1 
                FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES AS gtr 
                WHERE gtr.GRANTED_ON = 'ROLE' 
                    AND gtr.PRIVILEGE = 'USAGE' 
                    AND gtr.NAME = r.NAME 
                    AND DELETED_ON IS NULL 
                ) 
), --CONNECT BY to create the polyarchy and SYS_CONNECT_BY_PATH to flatten it 
ROLE_PATH_PRE AS( 
    SELECT NAME
        ,LEVEL
        ,SYS_CONNECT_BY_PATH(name, ' -> ') AS PATH 
    FROM ROLE_HIER CONNECT BY GRANTEE_NAME = PRIOR NAME START WITH GRANTEE_NAME = 'root' 
    ORDER BY PATH 
), --Removing leading delimiter separately since there is some issue with how it interacted with sys_connect_by_path 
ROLE_PATH AS ( 
    SELECT NAME
        ,LEVEL
        ,SUBSTR(PATH, LEN(' -> ')) AS PATH 
    FROM ROLE_PATH_PRE 
), --Joining in privileges from GRANT_TO_ROLES 
ROLE_PATH_PRIVS AS ( 
    SELECT PATH
        ,rp.NAME AS ROLE_NAME
        ,privs.PRIVILEGE 
        ,GRANTED_ON
        ,privs.NAME AS PRIV_NAME
        ,'Role ' || PATH || ' has ' || PRIVILEGE || ' on ' || GRANTED_ON	|| ' ' || privs.NAME AS Description 
    FROM ROLE_PATH AS RP LEFT JOIN SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES AS PRIVS 
        ON RP.NAME = PRIVS.GRANTEE_NAME AND PRIVS.GRANTED_ON != 'ROLE' AND DELETED_ON IS NULL 
    ORDER BY PATH 
), --Aggregate total number of priv's per role, including hierarchy 
ROLE_PATH_PRIVS_AGG AS ( 
    SELECT TRIM(SPLIT(PATH, ' -> ') [0]) AS ROLE
        ,COUNT(*) AS NUM_OF_PRIVS 
    FROM ROLE_PATH_PRIVS 
    GROUP BY TRIM(SPLIT(PATH, ' -> ') [0]) 
    ORDER BY NUM_OF_PRIVS DESC 
) --Most Dangerous Man - final query 
SELECT GRANTEE_NAME AS USER
    ,COUNT(a.ROLE) AS NUM_OF_ROLES
    ,SUM(NUM_OF_PRIVS) AS NUM_OF_PRIVS 
FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_USERS AS u 
JOIN ROLE_PATH_PRIVS_AGG AS a ON a.ROLE = u.ROLE 
WHERE U.DELETED_ON IS NULL 
GROUP BY USER 
ORDER BY NUM_OF_PRIVS DESC;  