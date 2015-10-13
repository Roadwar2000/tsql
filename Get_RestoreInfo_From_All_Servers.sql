--set XACT_ABORT on;

DECLARE @sqlstatement VARCHAR(1000)
Declare @startdt varchar(8)
Declare @enddt varchar(8)

set @startdt = convert(varchar(8),getdate() - 990,112)
set @enddt = convert(varchar(8),getdate() ,112)
--
--@@SERVERNAME as ServerName, 

SELECT  @sqlstatement = 'SELECT restorehistory.dbname,
convert(nvarchar(19),restore_start,100) as restore_Start,
duration,
        restorehistory.size,
        speed,
restorefiles.name,restorelog.code,restorehistory.restore_type
          FROM restorelog 
          LEFT JOIN restorehistory ON restorelog.restore_id = restorehistory.id 
          LEFT JOIN restorefiles on restorehistory.id = restorefiles.restore_id 
WHERE  restorelog.sqlerrorcode = 0 or 1=1
order by restorehistory.id Desc;'

--print @sqlstatement
--INSERT INTO [INF-1MMQBK1-L].[ServerTools].[dbo].[BackupInfo] (DatabaseName,Backup_Start,Duration,[Size],Speed,Threads,FileName)
EXECUTE MASTER..sqbdata @sqlstatement;
--update [HDIRPT01].[HDIEventLog].[dbo].[BackupInfo] set servername=@@SERVERNAME where servername is NULL;
--set XACT_ABORT off;