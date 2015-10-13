-- Grant permissions for newly 
declare @vcExec varchar(4000)

declare MakeRights cursor FOR
with databases2do as
(select name
from sys.databases
where database_id>4 and name <> 'distribution' AND STATE_DESC='ONLINE'
and not name in (
select substring(replace(substring(name,9,100), @@servername+'-', ''), 1, len(replace(substring(name,9,100), @@servername+'-', ''))-2)
from sys.server_principals
where type='G' and is_disabled = 0 and name like 'HDI\SQL-%-R'))
select 'USE ['+upper(name)+']; '+'CREATE USER [HDI\SQL-'+@@servername+'-'+upper(name)+'-R] FOR LOGIN [HDI\SQL-'+@@servername+'-'+upper(name)+'-R]'+'; EXEC sp_addrolemember [db_datareader], [HDI\SQL-'+@@servername+'-'+upper(name)+'-R]'
from databases2do
union all
select 'USE ['+upper(name)+']; '+'CREATE USER [HDI\SQL-'+@@servername+'-'+upper(name)+'-RW] FOR LOGIN [HDI\SQL-'+@@servername+'-'+upper(name)+'-RW]'+'; EXEC sp_addrolemember [db_datareader], [HDI\SQL-'+@@servername+'-'+upper(name)+'-RW]; EXEC sp_addrolemember [db_datawriter], [HDI\SQL-'+@@servername+'-'+upper(name)+'-RW]'
from databases2do
union all
select 'USE ['+upper(name)+']; '+'CREATE USER [HDI\SQL-'+@@servername+'-'+upper(name)+'-O] FOR LOGIN [HDI\SQL-'+@@servername+'-'+upper(name)+'-O]'+'; EXEC sp_addrolemember [db_owner], [HDI\SQL-'+@@servername+'-'+upper(name)+'-O]'
from databases2do
union all
select 'USE ['+upper(name)+']; '+'CREATE USER [HDI\SQL-'+@@servername+'-'+upper(name)+'-RWE] FOR LOGIN [HDI\SQL-'+@@servername+'-'+upper(name)+'-RWE]'+'; EXEC sp_addrolemember [db_datareader], [HDI\SQL-'+@@servername+'-'+upper(name)+'-RWE]; EXEC sp_addrolemember [db_datawriter], [HDI\SQL-'+@@servername+'-'+upper(name)+'-RWE]; GRANT EXECUTE TO [HDI\SQL-'+@@servername+'-'+upper(name)+'-RWE]'
from databases2do
union all
select 'USE ['+upper(name)+']; '+'CREATE USER [HDI\SQL-'+@@servername+'-'+upper(name)+'-C] FOR LOGIN [HDI\SQL-'+@@servername+'-'+upper(name)+'-C]'+'; EXEC sp_addrolemember [db_datareader], [HDI\SQL-'+@@servername+'-'+upper(name)+'-C]; EXEC sp_addrolemember [db_datawriter], [HDI\SQL-'+@@servername+'-'+upper(name)+'-C]; GRANT EXECUTE TO [HDI\SQL-'+@@servername+'-'+upper(name)+'-C]; GRANT ALTER TO [HDI\SQL-'+@@servername+'-'+upper(name)+'-C]'+'; GRANT CREATE DEFAULT TO [HDI\SQL-'+@@servername+'-'+upper(name)+'-C]'+'; GRANT CREATE FUNCTION TO [HDI\SQL-'+@@servername+'-'+upper(name)+'-C]'+'; GRANT CREATE PROCEDURE TO [HDI\SQL-'+@@servername+'-'+upper(name)+'-C]'+'; GRANT CREATE RULE TO [HDI\SQL-'+@@servername+'-'+upper(name)+'-C]'+'; GRANT CREATE TABLE TO [HDI\SQL-'+@@servername+'-'+upper(name)+'-C]'+'; GRANT CREATE TYPE TO [HDI\SQL-'+@@servername+'-'+upper(name)+'-C]'+'; GRANT CREATE VIEW TO [HDI\SQL-'+@@servername+'-'+upper(name)+'-C]'+'; GRANT SHOWPLAN TO [HDI\SQL-'+@@servername+'-'+upper(name)+'-C]'+'; GRANT VIEW DEFINITION TO [HDI\SQL-'+@@servername+'-'+upper(name)+'-C]'+';'
from databases2do

OPEN MakeRights
FETCH NEXT FROM MakeRights INTO @vcExec

WHILE @@FETCH_STATUS = 0
BEGIN
	print @vcExec
	exec (@vcExec)
	FETCH NEXT FROM MakeRights INTO @vcExec
END
CLOSE MakeRights
DEALLOCATE MakeRights
