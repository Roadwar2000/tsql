select 'SELECT TOP 1 * FROM '+name+';' as Text
from sys.objects
where type ='V' and is_ms_shipped=0