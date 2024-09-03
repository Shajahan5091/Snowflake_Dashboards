SELECT 
    WAREHOUSE_NAME, 
    SUM(CREDITS_USED_CLOUD_SERVICES) CREDITS_USED_CLOUD_SERVICES, 
    SUM(CREDITS_USED_COMPUTE) CREDITS_USED_COMPUTE, 
    SUM(CREDITS_USED) CREDITS_USED 
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY 
GROUP BY 
    WAREHOUSE_NAME
ORDER BY 
    CREDITS_USED DESC 
LIMIT 10;  