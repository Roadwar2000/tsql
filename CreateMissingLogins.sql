-- Create missing LOGINs for all non-system databases on this server
declare @vcExec varchar(4000)

declare MakeLogins cursor FOR
with databases2do as
(select name
from sys.databases
where database_id>4 and name <> 'distribution'
and not name in (
select substring(replace(substring(name,9,100), @@servername+'-', ''), 1, len(replace(substring(name,9,100), @@servername+'-', ''))-2)
from sys.server_principals
where type='G' and is_disabled = 0 and name like 'HDI\SQL-%-R'))
select 'CREATE LOGIN [HDI\SQL-'+@@servername+'-'+upper(name)+'-R] FROM WINDOWS WITH DEFAULT_DATABASE=['+name+']'
from databases2do
union all
select 'CREATE LOGIN [HDI\SQL-'+@@servername+'-'+upper(name)+'-RW] FROM WINDOWS WITH DEFAULT_DATABASE=['+name+']'
from databases2do
union all
select 'CREATE LOGIN [HDI\SQL-'+@@servername+'-'+upper(name)+'-RWE] FROM WINDOWS WITH DEFAULT_DATABASE=['+name+']'
from databases2do
union all
select 'CREATE LOGIN [HDI\SQL-'+@@servername+'-'+upper(name)+'-O] FROM WINDOWS WITH DEFAULT_DATABASE=['+name+']'
from databases2do
union all
select 'CREATE LOGIN [HDI\SQL-'+@@servername+'-'+upper(name)+'-C] FROM WINDOWS WITH DEFAULT_DATABASE=['+name+']'
from databases2do

OPEN MakeLogins
FETCH NEXT FROM MakeLogins INTO @vcExec

WHILE @@FETCH_STATUS = 0
BEGIN
	print @vcExec
	exec (@vcExec)
	FETCH NEXT FROM MakeLogins INTO @vcExec
END
CLOSE MakeLogins
DEALLOCATE MakeLogins


