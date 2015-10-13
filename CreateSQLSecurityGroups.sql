-- Create missing AD groups for ALL non-system databases
with databases2do as
(select name
from sys.databases
where database_id>4 and name <> 'distribution'
and not name in (
select substring(replace(substring(name,9,100), @@servername+'-', ''), 1, len(replace(substring(name,9,100), @@servername+'-', ''))-2)
from sys.server_principals
where type='G' and is_disabled = 0 and name like 'HDI\SQL-%-R'))
select 'dsadd group "cn=SQL-'+@@servername+'-'+upper(name)+'-R,ou=SQL Server Security,ou=Service Accounts and Groups,dc=HDI,dc=com"'
from databases2do
union all
select 'dsadd group "cn=SQL-'+@@servername+'-'+upper(name)+'-RW,ou=SQL Server Security,ou=Service Accounts and Groups,dc=HDI,dc=com"'
from databases2do
union all
select 'dsadd group "cn=SQL-'+@@servername+'-'+upper(name)+'-RWE,ou=SQL Server Security,ou=Service Accounts and Groups,dc=HDI,dc=com"'
from databases2do
union all
select 'dsadd group "cn=SQL-'+@@servername+'-'+upper(name)+'-O,ou=SQL Server Security,ou=Service Accounts and Groups,dc=HDI,dc=com"'
from databases2do
union all
select 'dsadd group "cn=SQL-'+@@servername+'-'+upper(name)+'-C,ou=SQL Server Security,ou=Service Accounts and Groups,dc=HDI,dc=com"'
from databases2do

