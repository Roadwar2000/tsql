DECLARE @sqlstatement VARCHAR(1000)

SELECT @sqlstatement = 'SELECT 
backuphistory.dbname,
convert(nvarchar(19),backup_start,100) as Backup_Start,
duration,
backuphistory.size,
backuphistory.compressed_size --,
--backupfiles.name
,backuphistory.*
FROM backuplog LEFT JOIN backuphistory ON backuplog.backup_id = backuphistory.id 
LEFT JOIN backupfiles on backuphistory.id = backupfiles.backup_id 
WHERE backuplog.sqlerrorcode = 0 and backuplog.code = 0 AND 
backuphistory.backup_start >= ''5/27/2012'' AND 
backuphistory.backup_start <= ''5/28/2012'' AND
backuphistory.backup_type = ''D''
order by backuphistory.size Desc;'

--print @sqlstatement

EXECUTE MASTER..sqbdata @sqlstatement