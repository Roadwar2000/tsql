--set XACT_ABORT on;

DECLARE @sqlstatement VARCHAR(1000)
Declare @startdt varchar(8)
Declare @enddt varchar(8)

set @startdt = convert(varchar(8),getdate() - 990,112)
set @enddt = convert(varchar(8),getdate() ,112)
--
--@@SERVERNAME as ServerName, 
SELECT  @sqlstatement = 'SELECT backuphistory.dbname,
convert(nvarchar(19),backup_start,100) as Backup_Start,
duration,
        backuphistory.size,
        speed,
        threads,
backupfiles.name
          FROM backuplog LEFT JOIN backuphistory ON backuplog.backup_id = backuphistory.id 
          LEFT JOIN backupfiles on backuphistory.id = backupfiles.backup_id 
WHERE  backuplog.sqlerrorcode = 0 
and backuplog.code = 0
and backuphistory.backup_start >= '''+ @startdt+''' 
and backuphistory.backup_start <= '''+ @enddt+'''
order by backuphistory.id Desc;'

--print @sqlstatement
--INSERT INTO [INF-1MMQBK1-L].[ServerTools].[dbo].[BackupInfo] (DatabaseName,Backup_Start,Duration,[Size],Speed,Threads,FileName)
EXECUTE MASTER..sqbdata @sqlstatement;
--update [HDIRPT01].[HDIEventLog].[dbo].[BackupInfo] set servername=@@SERVERNAME where servername is NULL;
--set XACT_ABORT off;