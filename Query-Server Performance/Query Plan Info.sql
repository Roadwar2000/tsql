select p.query_plan,r.* ,getdate()
from sys.dm_exec_requests r
cross apply sys.dm_exec_query_plan(r.plan_handle) p
where (total_elapsed_time/1000.00)/60 > 1