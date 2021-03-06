-- For ALL SQL Servers, show the oldest and newest total drive sizes with growth percentage
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
, results as (
select s.servername,[year],[month],Size,row_number() over(partition by servername order by [year],[month]) as rn
from mycte m
join [SQLServerMDB].[server].[Server] s on s.id = m.serverid
where left(servername,2)<>'DR'
), finaltable as (
select r1.servername,r1.[year], r1.[month], r1.size as Size_Oldest, r2.size as Size_Newest
from results r1
left join results r2 on r1.servername=r2.servername and r2.rn = (select max(rn) from results r0 where r0.servername=r1.servername)
where r1.[month]=11
--group by r1.servername,r1.[year], r1.[month]
)
select servername,size_oldest,size_newest,size_newest-size_oldest as growth
from finaltable
order by growth desc
--order by 1,2,3
/*
select s.servername,[year],[month],DataSpaceUsage,IndexSpaceUsage,Size,SpaceAvailable,row_number() over(partition by servername order by [year],[month]) as rn
from mycte m
join [SQLServerMDB].[server].[Server] s on s.id = m.serverid
where left(servername,2)<>'DR'
order by 1,2,3
*/