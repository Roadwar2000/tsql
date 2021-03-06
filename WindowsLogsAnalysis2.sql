SELECT TOP 1000 [server]
      --,[Date]
	  ,[DateTime]
      --,[Message]
      --,[Faulting application name]
      --,[Faulting module name]
      --,[Exception code]
      --,[Fault offset]
      --,[Faulting process id]
      --,[Faulting application start time]
      --,[Faulting application path]
      --,[Faulting module path]
      --,[Report Id]

select datepart(dayofyear, date) as doy, server, count(*)
  FROM [_Citrix].[dbo].[WindowsLogs3]
  where  message like 'Faulting%' 
  --and server='vmclxa6-QA01'
  group by datepart(dayofyear, date), server
  order by 1,2 desc --,1


  select count(*),server
  FROM [_Citrix].[dbo].[WindowsLogs3]
  where  message like 'Faulting%' 
  group by server
  order by 1 desc