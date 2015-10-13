select *
  FROM [ProductionJobs].[dbo].[HDIProductionLog]
where starttime>='5/20/2011' and totcount is not null and totcount>0 and datepart(hour,starttime) between 8 and 11
order by starttime desc
---------------------------------------------------------------------------
SELECT 
      sum([TotCount])
      ,datepart(day,starttime)
     
  FROM [ProductionJobs].[dbo].[HDIProductionLog]
  where starttime>='5/1/2011' and datepart(hour,starttime) between 8 and 11
  group by datepart(day,starttime)
  order by datepart(day,starttime)
  
  select datediff(s, starttime, endtime)/3600.0 as [total time],*
  FROM [ProductionJobs].[dbo].[HDIProductionLog]
  where filename='RecoupPRG.dbo.PRGStatus'
  order by starttime desc
