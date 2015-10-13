--Foreign Keys in current database
select *
from sys.objects
where is_ms_shipped=0 and type='F'