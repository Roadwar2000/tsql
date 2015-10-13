DECLARE @SQL varchar(max);
with UncompressedTables as (
select distinct 'ALTER TABLE ['+SCHEMA_NAME(sys.objects.schema_id)+'].['+OBJECT_NAME(sys.objects.object_id)+'] REBUILD WITH (DATA_COMPRESSION=PAGE);' as RebuildTable
from sys.partitions
inner join sys.objects ON sys.partitions.object_id = sys.objects.object_id 
WHERE data_compression = 0 AND SCHEMA_NAME(sys.objects.schema_id) <> 'SYS' 
)
select @SQL = coalesce(@SQL,''+char(13)+char(10)) + RebuildTable + CHAR(13)+char(10)
FROM (
select TOP 1000 RebuildTable,(ROW_NUMBER() over (order by RebuildTable))*2-1 as rownumber
from UncompressedTables
union all
select TOP 1000 'GO',(ROW_NUMBER() over (order by RebuildTable))*2 as rownumber
from UncompressedTables
order by rownumber
) SQLCode
order by rownumber

print @sql
go