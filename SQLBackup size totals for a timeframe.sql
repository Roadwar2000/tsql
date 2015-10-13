DECLARE @sqlstatement VARCHAR(1000)
SELECT @sqlstatement = 'SELECT
backup_type,
count(dbname)as Database_Count,
sum(backuphistory.size) / 1000000 as Sum_Size_MB,
sum(backuphistory.compressed_size) /1000000 as Sum_Compressed_Size_MB

FROM backuplog 
LEFT JOIN backuphistory ON backuplog.backup_id = backuphistory.id 
LEFT JOIN backupfiles on backuphistory.id = backupfiles.backup_id 
WHERE 
backuplog.sqlerrorcode = 0 and backuplog.code = 0 AND 
backuphistory.backup_start >= ''1/01/2012'' AND 
backuphistory.backup_start <= ''12/31/2012'' GROUP BY backup_type
;'

--print @sqlstatement

EXECUTE MASTER..sqbdata @sqlstatement