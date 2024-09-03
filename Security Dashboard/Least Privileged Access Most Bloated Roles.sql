--Role Hierarchy 

WITH ROLE_HIER AS ( 
    --Extract all Roles 
    SELECT GRANTEE_NAME
        ,NAME 
    FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES 
    WHERE GRANTED_ON = 'ROLE' 
        AND PRIVILEGE = 'USAGE' 
        AND DELETED_ON IS NULL 
    UNION ALL 
        --Adding in dummy records for "root" roles 
    SELECT 'root'
        ,r.NAME 
    FROM SNOWFLAKE.ACCOUNT_USAGE.ROLES r 
    WHERE DELETED_ON IS NULL AND NOT EXISTS ( 
        SELECT 1 
        FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES gtr 
        WHERE gtr.GRANTED_ON = 'ROLE' 
            AND gtr.PRIVILEGE = 'USAGE' 
            AND gtr.NAME = r.NAME 
            AND DELETED_ON IS NULL 
        ) 
), --CONNECT BY to create the polyarchy and SYS_CONNECT_BY_PATH to flatten it 
ROLE_PATH_PRE AS( 
    SELECT NAME 
        ,LEVEL
        ,SYS_CONNECT_BY_PATH(NAME, ' -> ') AS PATH 
    FROM ROLE_HIER CONNECT BY GRANTEE_NAME = PRIOR NAME START WITH GRANTEE_NAME = 'root' 
    ORDER BY PATH 
), --Removing leading delimiter separately since there is some issue with how it 	interacted with sys_connect_by_path 
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
        ,'Role ' || PATH || ' has ' || PRIVILEGE || ' on ' || GRANTED_ON || '	' || privs.NAME AS Description 
    FROM ROLE_PATH rp LEFT JOIN SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES privs 
        ON rp.NAME = privs.GRANTEE_NAME AND privs.GRANTED_ON != 'ROLE' AND DELETED_ON IS NULL 
    ORDER BY PATH 
), --Aggregate total number of privy’s per role, including hierarchy 
ROLE_PATH_PRIVS_AGG AS ( 
    SELECT TRIM(SPLIT(PATH, ' -> ') [0]) AS ROLE
        ,COUNT(*) AS NUM_OF_PRIVS 
    FROM ROLE_PATH_PRIVS 
    GROUP BY TRIM(SPLIT(PATH, ' -> ') [0]) 
    ORDER BY NUM_OF_PRIVS DESC 
)  
SELECT *  
FROM ROLE_PATH_PRIVS_AGG  
ORDER BY NUM_OF_PRIVS DESC; 