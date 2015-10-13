CREATE TABLE _LogAlex (
LogID int IDENTITY (1,1),
LogDateTime datetime default (getdate()),
LogSUserName varchar(50) default (suser_name()),
LogHostName varchar(50) default (host_name()),
LogStepDesc varchar(100),
LogQueryID varchar(50) NULL,
LogTSQL varchar(8000) NULL)
GO
ALTER TABLE dbo._LogAlex ADD CONSTRAINT
	PK_LogAlex PRIMARY KEY CLUSTERED 
	(
	LogID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE PROCEDURE LogActivity 
@LogStepDesc varchar(100),
@LogQueryID varchar(50) = '',
@LogTSQL varchar(8000) = ''
AS
BEGIN
   INSERT INTO _LogAlex (LogStepDesc, LogQueryID, LogTSQL) VALUES (@LogStepDesc, @LogQueryID, @LogTSQL)
END
GO
EXEC LogActivity 'First Step','QueryID1','SELECT * FROM Detail'
GO