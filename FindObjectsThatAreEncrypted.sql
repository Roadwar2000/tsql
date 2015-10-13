sp_msforeachdb 'use [?];
SELECT ''?'' as DatabaseName,
o.name
from sys.objects o
join sys.syscomments c on c.id = o.object_id and c.encrypted=1
where type=''P''
'