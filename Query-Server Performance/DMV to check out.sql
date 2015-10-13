SELECT * FROM sys.dm_db_missing_index_details
go
select * from sys.dm_db_partition_stats order by 2
go
select * from sys.dm_db_index_physical_stats
go
select * from sys.dm_io_pending_io_requests
go
select db_name(mf.database_id) as dbname,
mf.physical_name,
divfs.num_of_reads,
divfs.num_of_bytes_read/1000000000.0,
divfs.io_stall_read_ms,
divfs.num_of_writes,
divfs.num_of_bytes_written,
divfs.io_stall_write_ms,
divfs.io_stall,
size_on_disk_bytes,
getdate() as datetimenow
 from sys.dm_io_virtual_file_stats(null,null) as divfs
join sys.master_files as mf on mf.database_id = divfs.database_id and mf.file_id=divfs.file_id
order by 4 desc
go

SELECT TOP 2
        deqs.execution_count
       ,deqs.total_worker_time
       ,deqs.total_elapsed_time
       ,deqs.total_logical_reads
       ,deqs.total_logical_writes
       ,deqs.query_plan_hash
       ,deqp.query_plan
FROM    sys.dm_exec_query_stats AS deqs
        CROSS APPLY sys.dm_exec_text_query_plan(deqs.plan_handle, DEFAULT,
                                                DEFAULT) AS deqp
WHERE   deqp.dbid = 14
ORDER BY deqs.total_elapsed_time DESC

go
sp_helpindex "detail"