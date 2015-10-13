select name,log_reuse_wait_desc
from master.sys.databases
where log_reuse_wait_desc <> 'NOTHING'
order by name