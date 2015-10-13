-- I/O operations for each database file
select db_name(mf.database_id) as dbname,
mf.physical_name,
divfs.num_of_reads,
divfs.num_of_bytes_read,
divfs.io_stall_read_ms,
divfs.num_of_writes,
divfs.num_of_bytes_written,
divfs.io_stall_write_ms,
divfs.io_stall,
size_on_disk_bytes,
getdate() as datetimenow
 from sys.dm_io_virtual_file_stats(null,null) as divfs
join sys.master_files as mf on mf.database_id = divfs.database_id and mf.file_id=divfs.file_id
order by 5 desc

-- Top 100 highest cost queries on the server
SELECT TOP 100
[Total IO] = (qs.total_logical_reads + qs.total_logical_writes)
, [Average IO] = (qs.total_logical_reads + qs.total_logical_writes) /
qs.execution_count
, qs.execution_count
, SUBSTRING (qt.text,(qs.statement_start_offset/2) + 1,
((CASE WHEN qs.statement_end_offset = -1
THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
ELSE qs.statement_end_offset
END - qs.statement_start_offset)/2) + 1) AS [Individual Query]
, qt.text AS [Parent Query]
, DB_NAME(qt.dbid) AS DatabaseName
, qp.query_plan
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY [Total IO] DESC