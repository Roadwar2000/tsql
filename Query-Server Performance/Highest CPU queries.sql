select *
from sys.dm_exec_requests
-----------------------
select *
from sys.dm_os_schedulers
-----------------------
SELECT 
highest_cpu_queries.plan_handle,   
highest_cpu_queries.max_worker_time , 
highest_cpu_queries.total_worker_time,  
highest_cpu_queries.last_worker_time,  
highest_cpu_queries.min_worker_time, 
q.dbid,  
q.objectid,  
q.number,  
q.encrypted,  
q.[text]  
FROM   
(SELECT TOP 10   
       qs.plan_handle,   
        qs.total_worker_time, 
        qs.last_worker_time,  
        qs.min_worker_time, 
        qs.max_worker_time  
 FROM sys.dm_exec_query_stats qs  
ORDER BY qs.max_worker_time DESC) AS highest_cpu_queries  
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS q  
ORDER BY highest_cpu_queries.total_worker_time DESC