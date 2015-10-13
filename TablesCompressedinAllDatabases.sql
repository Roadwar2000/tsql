exec sp_msforeachdb 
'use [?]
SELECT db_name(),OBJECT_NAME(OBJECT_ID) AS [ObjectName], db_name()[rows], data_compression_desc, index_id   
FROM sys.partitions   
WHERE data_compression = 0 and rows > 500000 and left(OBJECT_NAME(OBJECT_ID),3)<>''sys''
ORDER BY ObjectName; '



exec sp_msforeachdb 
'use [?]
SELECT ''ALTER TABLE [''+db_name()+''].[dbo].[''+OBJECT_NAME(OBJECT_ID)+''] REBUILD WITH (DATA_COMPRESSION=PAGE)'' 
FROM sys.partitions   
WHERE data_compression = 0 and rows > 500000 and left(OBJECT_NAME(OBJECT_ID),3)<>''sys''
; '



