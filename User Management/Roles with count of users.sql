SHOW ROLES; 

SELECT "name" as ROLES
    ,"assigned_to_users" as ASSIGNED_TO_USERS  
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))  
WHERE "assigned_to_users" >= 1;
