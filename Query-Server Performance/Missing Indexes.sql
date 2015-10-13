SELECT user_seeks * avg_total_user_cost * (avg_user_impact * 0.01) as index_advantage,
dbmigs.last_user_seek,
dbmid.[statement] as [Database.Schema.Table],
dbmid.equality_columns,
dbmid.inequality_columns,
dbmid.included_columns,
dbmigs.unique_compiles,
dbmigs.user_seeks,
dbmigs.avg_total_user_cost,
dbmigs.avg_user_impact
FROM sys.dm_db_missing_index_group_stats as dbmigs with (nolock)
INNER JOIN sys.dm_db_missing_index_groups as dbmig with (nolock) ON dbmigs.group_handle = dbmig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details as dbmid with (nolock) ON dbmig.index_handle = dbmid.index_handle
WHERE dbmid.[database_id] = DB_ID()
ORDER BY index_advantage DESC
