ALTER SESSION SET TIMEZONE = UTC; 

SELECT NAME
    ,COUNT(*) AS COUNT 
FROM SNOWFLAKE.ACCOUNT_USAGE.TASK_HISTORY  
WHERE MONTH(SCHEDULED_TIME) = MONTH(CURRENT_DATE) 
    AND MONTH(COMPLETED_TIME) = MONTH(CURRENT_DATE) 
GROUP BY NAME 
ORDER BY COUNT DESC; 