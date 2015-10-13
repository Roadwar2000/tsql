SELECT SUBSTRING(CONVERT(varchar,serverproperty('servername')),1,40) 'Instance',
  CONVERT(sysname,@@version) 'Version', DATEDIFF(d, crdate,GETDATE()) 'Days Online'
FROM master.dbo.sysdatabases
WHERE name='tempdb' --and DATEDIFF(d, crdate,GETDATE()) >30
--order by DATEDIFF(d, crdate,GETDATE()) desc