exec sp_msforeachdb 'use [?];
SELECT SCHEMA_NAME(t.schema_id) AS schema_name, t.name AS table_name, 
i.rows
FROM sys.tables AS t INNER JOIN
sys.sysindexes AS i ON t.object_id = i.id AND i.indid < 2
'