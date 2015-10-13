-- For any given SQL ServerName, show the year, month and drive sizes
with mycte as (
SELECT datepart(yy, recorddate) as [year]
      ,datepart(m,[RecordDate]) as [month]
	  , [ServerID]
      ,sum([DataSpaceUsage]) as DataSpaceUsage
      ,sum([IndexSpaceUsage]) as IndexSpaceUsage
      ,sum([Size]) as Size
      ,sum([SpaceAvailable]) as SpaceAvailable
  FROM [SQLServerMDB].[history].[Database]
  where datepart(d,recorddate)=1 
  group by datepart(yy, recorddate),datepart(m,[RecordDate]),serverid
)
select s.servername,[year],[month],DataSpaceUsage,IndexSpaceUsage,Size,SpaceAvailable,row_number() over(partition by servername order by [year],[month]) as rn
from mycte m
join [SQLServerMDB].[server].[Server] s on s.id = m.serverid
where left(servername,2)<>'DR' and servername='CLCOMSQL07'
order by 1,2,3
