--To help build a data dictionary of all the fields and their usage
select name,count(*)
from sys.columns
group by name
order by count(*) desc

--insert into _object (TableName, TableObjectName) 
select --distinct 
s.name+'.'+o.name as [Table]
--, 'ID' as [TableObjectName]
,c.name as [column]
from sys.columns c
join sys.objects o on o.object_id = c.object_id
join sys.schemas s on s.schema_id = o.schema_id
where c.name <> 'id' and c.max_length=-1 --VARCHAR(MAX) column size
and o.is_ms_shipped = 0 and o.type = 'U' 
--and not s.name+'.'+o.name in (select tablename from [_object]))) and not s.name+'.'+o.name in ('dbo._Comment','dbo.sysdiagrams')
--and not s.name in ('Hist','Logs')
order by o.name,c.name --c.max_length desc

--Tables in current DB
select *
from sys.objects o
where o.is_ms_shipped = 0 and o.type = 'U'

--Tables with a particular schema name
select *
from sys.schemas s 
join sys.objects o on s.schema_id = o.schema_id
where s.name = 'Hist'