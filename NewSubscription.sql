-----------------BEGIN: Script to be run at Publisher 'HDIRACFTP'-----------------
use [CDWINNT]
exec sp_addsubscription @publication = N'HDIRACFTP_CDWINNT', @subscriber = N'lvcmsd02', @destination_db = N'ConnectDirect', @sync_type = N'Automatic', @subscription_type = N'pull', @update_mode = N'read only'
GO
-----------------END: Script to be run at Publisher 'HDIRACFTP'-----------------

-----------------BEGIN: Script to be run at Subscriber 'lvcmsd02'-----------------
use [ConnectDirect]
exec sp_addpullsubscription @publisher = N'HDIRACFTP', @publication = N'HDIRACFTP_CDWINNT', @publisher_db = N'CDWINNT', @independent_agent = N'True', @subscription_type = N'pull', @description = N'', @update_mode = N'read only', @immediate_sync = 0

exec sp_addpullsubscription_agent @publisher = N'HDIRACFTP', @publisher_db = N'CDWINNT', @publication = N'HDIRACFTP_CDWINNT', @distributor = N'LVCMSD02', @distributor_security_mode = 1, @distributor_login = N'', @distributor_password = null, @enabled_for_syncmgr = N'False', @frequency_type = 64, @frequency_interval = 0, @frequency_relative_interval = 0, @frequency_recurrence_factor = 0, @frequency_subday = 0, @frequency_subday_interval = 0, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 20110821, @active_end_date = 99991231, @alt_snapshot_folder = N'', @working_directory = N'', @use_ftp = N'False', @job_login = null, @job_password = null, @publication_type = 0
GO
-----------------END: Script to be run at Subscriber 'lvcmsd02'-----------------

