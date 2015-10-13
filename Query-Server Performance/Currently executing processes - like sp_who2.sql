SELECT
es.session_id
,es.status
,es.login_name
,DB_NAME(er.database_id) as database_name
,es.host_name
,es.program_name
,er.blocking_session_id
,er.command
,es.reads
,es.writes
,es.cpu_time
,er.wait_type
,er.wait_time
,er.last_wait_type
,er.wait_resource
,CASE es.transaction_isolation_level WHEN 0 THEN 'Unspecified'
WHEN 1 THEN 'ReadUncommitted'
WHEN 2 THEN 'ReadCommitted'
WHEN 3 THEN 'Repeatable'
WHEN 4 THEN 'Serializable'
WHEN 5 THEN 'Snapshot'
END AS transaction_isolation_level
,OBJECT_NAME(st.objectid, er.database_id) as object_name
,SUBSTRING(st.text, er.statement_start_offset / 2,
(CASE WHEN er.statement_end_offset = -1 THEN LEN(CONVERT(nvarchar(max), st.text)) * 2
ELSE er.statement_end_offset END - er.statement_start_offset) / 2) AS query_text
,ph.query_plan
FROM sys.dm_exec_connections ec
LEFT OUTER JOIN sys.dm_exec_sessions es ON ec.session_id = es.session_id
LEFT OUTER JOIN sys.dm_exec_requests er ON ec.connection_id = er.connection_id
OUTER APPLY sys.dm_exec_sql_text(sql_handle) st
OUTER APPLY sys.dm_exec_query_plan(plan_handle) ph
WHERE ec.session_id <> @@SPID
AND es.status = 'running'
ORDER BY es.session_id
