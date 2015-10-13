Create procedure ProcedurePlans
as
select object_name(ps.object_id, ps.database_id) as procedurename
,ps.execution_count as ProcedureExecutes
,qs.plan_generation_num as VersionOfPlan
,qs.execution_count as ExecutionsOfCurrentPlan
,substring(st.text, (qs.statement_start_offset/2)+1, ((case statement_end_offset when -1 then datalength([st].[text]) else qs.statement_end_offset end - qs.statement_start_offset)/2)+1) as StatementText
,qs.statement_start_offset as offset
,qs.statement_end_offset as offset_end
,qp.query_plan as [Query Plan XML]
,qs.query_hash as [Query Fingerprint]
,qs.query_plan_hash as [Query Plan Fingerprint]
from [sys].[dm_exec_procedure_stats] as ps
join sys.dm_exec_query_stats as qs on ps.plan_handle = qs.plan_handle
cross apply sys.dm_exec_query_plan (qs.plan_handle) as qp
cross apply sys.dm_exec_sql_text (qs.sql_handle) as st
where ps.database_id = db_id() and object_name(ps.object_id, ps.database_id) not in (N'procedureplans', N'RecompileEvents')
order by procedurename,qs.statement_start_offset