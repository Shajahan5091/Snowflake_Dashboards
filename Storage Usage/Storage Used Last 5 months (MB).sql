SELECT DATE_TRUNC(MONTH, USAGE_DATE) AS USAGE_MONTH
    ,AVG(STORAGE_BYTES + STAGE_BYTES + FAILSAFE_BYTES) / POWER(1024, 2) AS BILLABLE_MB
    ,AVG(STORAGE_BYTES) / POWER(1024, 2) AS STORAGE_MB
    ,AVG(STAGE_BYTES) / POWER(1024, 2) AS STAGE_MB
    ,AVG(FAILSAFE_BYTES) / POWER(1024, 2) AS FAILSAFE_MB 
FROM SNOWFLAKE.ACCOUNT_USAGE.STORAGE_USAGE 
GROUP BY USAGE_MONTH    	 
ORDER BY USAGE_MONTH    	 
LIMIT 5;  