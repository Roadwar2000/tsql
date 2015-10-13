SELECT [ServerName]
      ,[DriveLetter]
      ,[Description]
      ,[RecordDate]
      ,[Capacity]
      ,[FreeSpace]
      ,[Usedspace]
      ,[CreateDate]
      ,[UpdateDate]
	  ,freespace*100.0/CAST(capacity as DECIMAL(10,2)) as PercFree
  FROM [SQLServerMDB].[reporting].[VolumeDetail]
  where recorddate='08/10/2014'
  and servername like '%SQL%' 
  and not servername in ( 'VMCLSQLTST01','CLMGTSQLPD1')
  and not driveletter in ('D:\','I:\')
  order by 1,2,capacity desc