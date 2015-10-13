USE [RecoupCMS]
GO
CREATE TABLE [dbo].[_LogTimesRedox](
	[LogGUID] [uniqueidentifier] NOT NULL,
	[LogDateTime] [datetime] NOT NULL,
	[LogMessage] varchar(100) NULL,
	[LogDateTimeEnd] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[_LogTimesRedox] ADD  CONSTRAINT [DF__LogTimesRedox_LogDateTime]  DEFAULT (getdate()) FOR [LogDateTime]
GO

CREATE PROCEDURE usp_LogTimesRedoxAdd
@LogMessage VARCHAR(100), @LogGUID uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON

	--DECLARE @LogGUID uniqueidentifier = NEWID()
	INSERT INTO [dbo].[_LogTimesRedox]
			   ([LogGUID]
			   ,[LogMessage])
		 VALUES
			   (@LogGUID
			   ,@LogMessage)

END
GO
CREATE PROCEDURE usp_LogTimesRedoxUpdate
@LogGUID uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON

	UPDATE [dbo].[_LogTimesRedox]
	SET LogDateTimeEnd = GETDATE()
	WHERE LogGUID = @LogGUID and LogDateTimeEnd IS NULL

END