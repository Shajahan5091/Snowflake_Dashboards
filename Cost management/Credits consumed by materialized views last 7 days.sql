select *
  from table(snowflake.information_schema.materialized_view_refresh_history(
    date_range_start=>dateadd(D, -7, current_date),
    date_range_end=>current_date));