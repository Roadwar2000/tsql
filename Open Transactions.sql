select (select login_name from sys.dm_exec_sessions sess where req.session_id = sess.session_id) as LoginName,(select name from sys.databases db where db.database_id = req.database_id) as database_name,*
from sys.dm_exec_requests req
where open_transaction_count > 0

SELECT text,* 
FROM sys.dm_tran_session_transactions tst INNER JOIN sys.dm_exec_connections ec ON tst.session_id = ec.session_id
 CROSS APPLY sys.dm_exec_sql_text(ec.most_recent_sql_handle)