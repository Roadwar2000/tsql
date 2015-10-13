select wait_type,
waiting_tasks_count,
wait_time_ms / 1000.0 as wait_time_sec,
case when waiting_tasks_count = 0 THEN NULL ELSE wait_time_ms / 1000.0 / waiting_tasks_count END as avg_wait_time_ms,
max_wait_time_ms / 1000.0 as max_wait_time_sec,
(wait_time_ms - signal_wait_time_ms) / 1000.0 as resource_wait_time_sec
from sys.dm_os_wait_stats
where wait_type not in ('WAITFOR','SLEEP_SYSTEMTASK','SLEEP_TASK','RESOURCE_QUEUE','LAZYWRITER_SLEEP','CLR_SEMAPHORE')
order by waiting_tasks_count desc