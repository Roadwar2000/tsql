--Calc total number of rows in this database
select sum(rows)
from (
SELECT SCHEMA_NAME(t.schema_id)+'.'+t.name AS table_name,cast(rows as bigint) as rows
FROM sys.tables AS t INNER JOIN
sys.sysindexes AS i ON t.object_id = i.id AND i.indid < 2
where t.type = 'U' and t.is_ms_shipped = 0
) a
