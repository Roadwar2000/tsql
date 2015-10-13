CREATE TRIGGER CompressTablesAfterCreation 
ON DATABASE 
AFTER CREATE_TABLE 
AS 
BEGIN 
	DECLARE @TableSchema sysname, @TableName sysname, @theTriggeringSQL nvarchar(max) 
	SELECT @TableSchema = EVENTDATA().value('(/EVENT_INSTANCE/SchemaName)[1]','sysname'), 
	@TableName = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'sysname'),
	@theTriggeringSQL = EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'nvarchar(max)')

	if (@theTriggeringSQL not like '%with%(%data\_compression%=%' escape '\' and @theTriggeringSQL not like 'select%')
	begin
		DECLARE @SQL NVARCHAR(2000) 

		SET @SQL = 'ALTER TABLE ' + QUOTENAME(@TableSchema) + '.' + 
		QUOTENAME(@TableName) + ' REBUILD WITH (DATA_COMPRESSION=PAGE)' 

		EXEC (@SQL) 
	end
END
