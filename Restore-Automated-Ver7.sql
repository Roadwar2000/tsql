
declare @TodaysDate varchar(50) = convert(varchar(50),getdate()-1,112), @Backup varchar(500), @Database varchar(50)
SET @Database = 'ProductionJobs'
SET @Backup = '-SQL "RESTORE DATABASE ['+@Database+'_'+@TodaysDate+'] FROM DISK = ''\\CLCMSD01FCDTC\Backups\*.sqb'' SOURCE = '''+@Database+''' LATEST_FULL WITH PASSWORD = ''3NcryPt(6)n'', RECOVERY, MOVE '''+@Database+''' TO ''K:\DataFiles\'+@Database+'_'+@TodaysDate+'.mdf'', MOVE '''+@Database+'_log'' TO ''H:\LogFiles\'+@Database+'_'+@TodaysDate+'_log.ldf''"'
print @Backup
EXECUTE master..sqlbackup @Backup
