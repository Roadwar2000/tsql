select *
from sys.database_principals
where type_desc='DATABASE_ROLE' and is_fixed_role <> 1 and name <> 'public'