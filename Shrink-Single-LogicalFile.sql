SET NOCOUNT ON
DECLARE @LogicalFileToShrink NVARCHAR(100) = 'LogicalFileName'
DECLARE @NewSize BIGINT   = 999999
DECLARE @FinalSize BIGINT = 500000
DECLARE @StartingSize BIGINT = @NewSize
DECLARE @ShrinkBy SMALLINT = 500 -- Shrink file by 500MB each time
DECLARE @EstTotalSecs FLOAT, @PercDone FLOAT
DBCC SHRINKFILE (@LogicalFileToShrink , 0, TRUNCATEONLY)
DECLARE @StartingTime DATETIME = GETDATE()
while @NewSize>@FinalSize
begin
	set @NewSize=@NewSize-@ShrinkBy
	SET @PercDone = 100.0*(@StartingSize-@NewSize)/(@StartingSize-@FinalSize)
	SET @EstTotalSecs = (100.0 /  @PercDone) * (DATEDIFF(s, @StartingTime,GETDATE()) * 1.0) 
	print 'Completed ' + left(cast(@PercDone as varchar(20)),5)+'%'
	print @NewSize
	print '    Current time ' + cast(getdate() as VARCHAR(30))
	print 'Est. finish time ' + cast(DATEADD(s, @estTotalSecs, @StartingTime) as VARCHAR(30))
	DBCC SHRINKFILE (@LogicalFileToShrink , @NewSize)
end
GO