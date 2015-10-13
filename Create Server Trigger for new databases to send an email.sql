CREATE TRIGGER [DDL_CREATE_DATABASE_EVENT]
ON ALL SERVER
FOR CREATE_DATABASE
AS
DECLARE @bd varchar(max)
Declare @tsql varchar(max)
Set @tsql = EVENTDATA().value
        ('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','varchar(max)')
SET @bd = 'UserName: ' + UPPER(SUSER_NAME()) + '

		   ServerName: ' + @@SERVERNAME + '

		   Time: '	+ CONVERT(varchar(25),Getdate()) + '

		   HostName: ' + HOST_NAME() + '

		   Database: ' + db_name() + '

		   T-SQL: ' +  @tsql
		   

BEGIN
PRINT 'Make sure you have informed all DBAs before creating databases. This event has been logged'

EXEC msdb.dbo.sp_send_dbmail @profile_name = 'standard',
							 @recipients = 'alex.state@emailhdi.com',
							 @subject = 'A new database has been created!',
							 @body_format = 'HTML',
							 @importance = 'High',
							 @body = @bd
END

GO

ENABLE TRIGGER [DDL_CREATE_DATABASE_EVENT] ON ALL SERVER
GO