use master
go
exec sp_msforeachdb 
'use [?]
select name,physical_name
from sys.database_files'