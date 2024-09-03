SELECT t1.table_id AS table_id
    ,any_value(t1.table_name) AS table_name
    ,sum(t1.rows_added) AS total_rows_added
    ,sum(t1.rows_removed) AS total_rows_removed
    ,sum(t1.rows_updated) AS total_rows_updated
    ,sum(t2.credits_used) AS total_automatic_clustering_credits 
FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_DML_HISTORY AS t1
JOIN SNOWFLAKE.ACCOUNT_USAGE.AUTOMATIC_CLUSTERING_HISTORY t2
    ON (t1.table_id = t2.table_id AND t1.schema_id = t2.schema_id AND t1.database_id = t2.database_id AND t1.start_time = t2.start_time)
WHERE t1.start_time >= dateadd(day, -7, current_timestamp())
GROUP BY t1.table_id
ORDER BY total_automatic_clustering_credits desc
