WITH core AS ( 
	SELECT DISTINCT 
		s.volume_mount_point [Drive],
		CAST(s.available_bytes / 1048576000.0 as decimal(20,2)) [AvailableGBs],
		CAST(s.total_bytes / 1048576000.0 as decimal(20,2)) [TotalGBs], 100.0 *
		CAST(s.available_bytes / 1048576000.0 as decimal(20,2)) /
		CAST(s.total_bytes / 1048576000.0 as decimal(20,2)) as [Percentage_Free]
	FROM 
		sys.master_files f
		CROSS APPLY sys.dm_os_volume_stats(f.database_id, f.[file_id]) s
)

SELECT [Drive],AvailableGBs,TotalGBs,[Percentage_Free]
FROM core
WHERE (AvailableGBs < .2 * TotalGBs or AvailableGBs < 20) and
left([DRIVE],1) <> 'I'
order by [Drive]