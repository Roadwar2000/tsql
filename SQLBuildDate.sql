--This T-SQL code determine the date/time the SQL install occured
select top 1 create_date
from sys.server_principals
where type = 'U'