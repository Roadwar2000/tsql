use master
go
exec sp_msforeachdb 
'use [?]
select ''ALTER DATABASE [?]''+'' SET OFFLINE;''
union all
select ''GO''
union all
select ''xp_cmdshell ''''move ''+physical_name+'' L:\datafiles''''''
from sys.database_files
union all
select ''GO''
union all
select ''ALTER DATABASE [?]''+'' MODIFY FILE (name=''''''+name+'''''', filename=''''''+physical_name+'''''')''
from sys.database_files
union all
select ''ALTER DATABASE [?]''+'' SET ONLINE;''
'


