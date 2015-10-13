-- What's running now?
-- all requests
SELECT  *
FROM    sys.dm_exec_requests AS der

-- eliminate the system calls
SELECT  *
FROM    sys.dm_exec_requests AS der
WHERE   der.session_id > 50

--active transactions
SELECT  *
FROM    sys.dm_tran_active_transactions AS dtat

--What ran recently
-- raw data
SELECT  *
FROM    sys.dm_exec_query_stats AS deqs
order by execution_count desc

--refining the request
SELECT  deqs.execution_count
       ,deqs.total_worker_time
       ,deqs.total_elapsed_time
       ,deqs.total_logical_reads
       ,deqs.total_logical_writes
       ,deqs.query_plan_hash
FROM    sys.dm_exec_query_stats AS deqs

-- Get the execution Plan
--Just the cached plans
SELECT  *
FROM    sys.dm_exec_cached_plans AS decp

-- to see the execution plan
SELECT  *
FROM    sys.dm_exec_cached_plans AS decp
        CROSS APPLY sys.dm_exec_query_plan(decp.plan_handle) AS deqp

select *
from sys.databases

-- only for the right database
SELECT  *
FROM    sys.dm_exec_cached_plans AS decp
        CROSS APPLY sys.dm_exec_query_plan(decp.plan_handle) AS deqp
WHERE   deqp.dbid = 33

-- combining with running processes
SELECT  der.session_id
       ,der.start_time
       ,der.wait_type
       ,der.wait_time
       ,der.last_wait_type
       ,der.wait_resource
       ,der.open_transaction_count
       ,der.cpu_time
       ,der.total_elapsed_time
       ,der.logical_reads
       ,der.writes
       ,der.granted_query_memory
       ,deqp.query_plan
FROM    sys.dm_exec_requests AS der
        CROSS APPLY sys.dm_exec_query_plan(der.plan_handle) AS deqp








-- combining with query stats
SELECT  deqs.execution_count
       ,deqs.total_worker_time
       ,deqs.total_elapsed_time
       ,deqs.total_logical_reads
       ,deqs.total_logical_writes
       ,deqs.query_plan_hash
       ,deqp.query_plan
FROM    sys.dm_exec_query_stats AS deqs
        CROSS APPLY sys.dm_exec_query_plan(deqs.plan_handle) AS deqp
WHERE   deqp.dbid = 14





--text plan with requests
SELECT  der.session_id
       ,der.start_time
       ,der.wait_type
       ,der.wait_time
       ,der.last_wait_type
       ,der.wait_resource
       ,der.open_transaction_count
       ,der.cpu_time
       ,der.total_elapsed_time
       ,der.logical_reads
       ,der.writes
       ,der.granted_query_memory
       ,deqp.query_plan
FROM    sys.dm_exec_requests AS der
        CROSS APPLY sys.dm_exec_text_query_plan(der.plan_handle,
                                                der.statement_start_offset,
                                                der.statement_end_offset) AS deqp






--text plan with stats & some filtering
SELECT TOP 2
        deqs.execution_count
       ,deqs.total_worker_time
       ,deqs.total_elapsed_time
       ,deqs.total_logical_reads
       ,deqs.total_logical_writes
       ,deqs.query_plan_hash
       ,deqp.query_plan
FROM    sys.dm_exec_query_stats AS deqs
        CROSS APPLY sys.dm_exec_text_query_plan(deqs.plan_handle, DEFAULT,
                                                DEFAULT) AS deqp
WHERE   deqp.dbid = 14
ORDER BY deqs.total_elapsed_time DESC







--Get the query
--The whole query
SELECT TOP 5
        dest.text
       ,deqs.execution_count
       ,deqs.total_elapsed_time
       ,deqs.max_elapsed_time
FROM    sys.dm_exec_query_stats AS deqs
        CROSS APPLY sys.dm_exec_sql_text(deqs.sql_handle) AS dest
ORDER BY deqs.max_elapsed_time DESC





--get the statement
--NOTE statement offset is divided by 2 because it measures unicode characters, not characters
SELECT  SUBSTRING(dest.text, (der.statement_start_offset / 2) + 1,
                  (der.statement_end_offset - der.statement_start_offset) / 2
                  + 1)
       ,LEN(dest.text) AS CharLength
       ,DATALENGTH(dest.text) AS DLength
       ,DATALENGTH(dest.text) / 2 AS HalfDLength
       ,der.statement_start_offset
       ,der.statement_end_offset
FROM    sys.dm_exec_requests AS der
        CROSS APPLY sys.dm_exec_sql_text(der.sql_handle) AS dest
WHERE   der.statement_end_offset > -1


SELECT  SUBSTRING(dest.text, (der.statement_start_offset / 2) + 1,
                  (der.statement_end_offset - der.statement_start_offset) / 2
                  + 1)
       ,LEN(dest.text) AS CharLength
       ,DATALENGTH(dest.text) AS DLength
       ,DATALENGTH(dest.text) / 2 AS HalfDLength
       ,der.statement_start_offset
       ,der.statement_end_offset
FROM    sys.dm_exec_query_stats AS der
        CROSS APPLY sys.dm_exec_sql_text(der.sql_handle) AS dest
WHERE   der.statement_end_offset > -1





--Index use
-- on a particular DB

SELECT  s.name + '.' + t.name AS TableName
       ,i.name AS IndexName
       ,i.index_id
       ,ddius.user_seeks
       ,ddius.user_scans
       ,ddius.user_updates
       ,ddius.user_lookups
FROM    sys.dm_db_index_usage_stats AS ddius
        JOIN sys.tables AS t
        ON ddius.object_id = t.object_id
        JOIN sys.schemas AS s
        ON t.schema_id = s.schema_id
        JOIN sys.indexes AS i
        ON ddius.index_id = i.index_id
           AND ddius.object_id = i.object_id
ORDER BY TableName
       ,ddius.index_id







--current activity, very low level
SELECT  i.name
       ,ddios.range_scan_count --range and table scans
       ,ddios.singleton_lookup_count --single row lookups
       ,ddios.row_lock_count
       ,ddios.row_lock_wait_count
       ,ddios.row_lock_wait_in_ms
       ,ddios.page_lock_count
       ,ddios.page_lock_wait_count
       ,ddios.page_lock_wait_in_ms
FROM    sys.dm_db_index_operational_stats(14, --Database Id
                                          DEFAULT, --Object Id
                                          DEFAULT, --Index Id
                                          DEFAULT--partition number
										) AS ddios
        JOIN sys.indexes AS i
        ON ddios.object_id = i.object_id
           AND ddios.index_id = i.index_id
WHERE   ddios.range_scan_count > 0
        AND ddios.singleton_lookup_count > 0






-- Fragmentation within the database
SELECT  i.name
       ,ddips.avg_fragmentation_in_percent
       ,ddips.fragment_count
       ,ddips.page_count
       ,ddips.avg_page_space_used_in_percent
       ,ddips.record_count
       ,ddips.avg_record_size_in_bytes
FROM    sys.dm_db_index_physical_stats(14, --Database ID
                                       DEFAULT, --Ojbect Id
                                       DEFAULT, --Index ID
                                       DEFAULT, --Partition
                                       'Sampled'--Mode DEFAULT NULL LIMITED(fastest) SAMPLED DETAILED(slowest)
									) AS ddips
        JOIN sys.indexes AS i
        ON ddips.object_id = i.object_id
           AND ddips.index_id = i.index_id
ORDER BY ddips.page_count DESC






--Missing Indexes

--generate a missing index
--straight out books online
SELECT  City
       ,StateProvinceID
       ,PostalCode
FROM    Person.Address
WHERE   StateProvinceID = 9 ;


SELECT  *
FROM    sys.dm_db_missing_index_details AS ddmid







--straight from BOL
SELECT  mig.*
       ,mid.statement AS table_name
       ,column_id
       ,column_name
       ,column_usage
FROM    sys.dm_db_missing_index_details AS mid
        CROSS APPLY sys.dm_db_missing_index_columns(mid.index_handle)
        INNER JOIN sys.dm_db_missing_index_groups AS mig
        ON mig.index_handle = mid.index_handle
ORDER BY mig.index_group_handle
       ,mig.index_handle
       ,column_id ;






--Not from BOL
WITH XMLNAMESPACES ('http://schemas.microsoft.com/sqlserver/2004/07/showplan'
    AS sp)
SELECT  p.query_plan.value(N'(sp:ShowPlanXML/sp:BatchSequence/sp:Batch/sp:Statements/sp:StmtSimple/sp:QueryPlan/sp:MissingIndexes/sp:MissingIndexGroup/sp:MissingIndex/@Database)[1]',
                           'NVARCHAR(256)') AS DatabaseName
       ,dest.text AS QueryText
       ,s.total_elapsed_time
       ,s.last_execution_time
       ,s.execution_count
       ,s.total_logical_writes
       ,s.total_logical_reads
       ,s.min_elapsed_time
       ,s.max_elapsed_time
       ,p.query_plan
       ,p.query_plan.value(N'(sp:ShowPlanXML/sp:BatchSequence/sp:Batch/sp:Statements/sp:StmtSimple/sp:QueryPlan/sp:MissingIndexes/sp:MissingIndexGroup/sp:MissingIndex/@Table)[1]',
                           'NVARCHAR(256)') AS TableName
       ,p.query_plan.value(N'(/sp:ShowPlanXML/sp:BatchSequence/sp:Batch/sp:Statements/sp:StmtSimple/sp:QueryPlan/sp:MissingIndexes/sp:MissingIndexGroup/sp:MissingIndex/@Schema)[1]',
                           'NVARCHAR(256)') AS SchemaName
       ,p.query_plan.value(N'(/sp:ShowPlanXML/sp:BatchSequence/sp:Batch/sp:Statements/sp:StmtSimple/sp:QueryPlan/sp:MissingIndexes/sp:MissingIndexGroup/@Impact)[1]',
                           'DECIMAL(6,4)') AS ProjectedImpact
       ,ColumnGroup.value('./@Usage', 'NVARCHAR(256)') AS ColumnGroupUsage
       ,ColumnGroupColumn.value('./@Name', 'NVARCHAR(256)') AS ColumnName
FROM    sys.dm_exec_query_stats s
        CROSS APPLY sys.dm_exec_query_plan(s.plan_handle) AS p
        CROSS APPLY p.query_plan.nodes('/sp:ShowPlanXML/sp:BatchSequence/sp:Batch/sp:Statements/sp:StmtSimple/sp:QueryPlan/sp:MissingIndexes/sp:MissingIndexGroup/sp:MissingIndex/sp:ColumnGroup')
        AS t1 (ColumnGroup)
        CROSS APPLY t1.ColumnGroup.nodes('./sp:Column') AS t2 (ColumnGroupColumn)
        CROSS APPLY sys.dm_exec_sql_text(s.sql_handle) AS dest
WHERE   p.query_plan.exist(N'/sp:ShowPlanXML/sp:BatchSequence/sp:Batch/sp:Statements/sp:StmtSimple/sp:QueryPlan//sp:MissingIndexes') = 1




