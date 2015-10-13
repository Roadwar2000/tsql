use productiontemp
go
select 'declare @dt varchar(50); set @dt=convert(varchar(50), getdate(),100); raiserror(''productiontemp %s'',0,0,@dt);'
union all
select 'go'
union all
select 'use productiontemp'
union all
select 'go'
union all
select distinct 'DBCC DBREINDEX(''' +SchemaName+'.'+tablename + ''');'
from (
SELECT OBJECT_SCHEMA_NAME(i.object_id) AS SchemaName,OBJECT_NAME(i.object_id) AS TableName,i.name AS TableIndexName,phystat.avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats(DB_ID('productiontemp'), NULL, NULL, NULL, 'DETAILED') phystat inner JOIN sys.indexes i 
ON i.object_id = phystat.object_id 
AND i.index_id = phystat.index_id 
WHERE phystat.fragment_count >= 25 and phystat.avg_fragmentation_in_percent >=10 and not OBJECT_NAME(i.object_id) like 'sys%'
) indexinfo 
union all
select 'go'

