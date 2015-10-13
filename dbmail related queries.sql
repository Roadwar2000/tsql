EXEC msdb.dbo.sysmail_help_status_sp;
EXEC msdb.dbo.sysmail_help_queue_sp @queue_type = 'mail';
SELECT --sent_account_id, sent_date 
* FROM msdb.dbo.sysmail_sentitems order by 21 desc
SELECT * FROM msdb.dbo.sysmail_event_log order by 3 desc

EXEC msdb.dbo.sysmail_start_sp;
EXEC msdb.dbo.sysmail_stop_sp;