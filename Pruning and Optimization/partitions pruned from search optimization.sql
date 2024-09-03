SELECT table_id
    ,ANY_VALUE(table_name) AS table_name
    ,SUM(partitions_pruned_default) / GREATEST(SUM(partitions_scanned) + SUM(partitions_pruned_default) + SUM(partitions_pruned_additional), 1) AS pruning_percentage_without_search
    ,SUM(partitions_pruned_additional + partitions_pruned_default) / GREATEST(SUM(partitions_scanned) + SUM(partitions_pruned_default) + SUM(partitions_pruned_additional), 1) AS pruning_percentage_with_search
    ,SUM(partitions_pruned_additional) AS total_partitions_pruned_from_search_optimization
FROM SNOWFLAKE.ACCOUNT_USAGE.SEARCH_OPTIMIZATION_BENEFITS
WHERE start_time >= DATEADD(day, -7, CURRENT_TIMESTAMP())
GROUP BY table_id
ORDER BY total_partitions_pruned_from_search_optimization DESC;