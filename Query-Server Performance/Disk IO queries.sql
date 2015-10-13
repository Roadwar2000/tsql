select * from sys.dm_db_partition_stats order by 2
select * from sys.dm_db_index_physical_stats
select * from sys.dm_io_pending_io_requests

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
