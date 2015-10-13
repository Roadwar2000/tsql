--Analysis of SQL Time-outs using Log table
select datepart(day, createdon) as day, datepart(hh, createdon) as hour,count(*) as perhour --, count(*)/21.6666 as perday
from Applicationlog..log (nolock)
where message like '%timeout%' and message like '%sql%' 
and createdon > getdate() - 30
and datepart(dw,createdon) between 2 and 6
group by datepart(day, createdon), datepart(hh, createdon)
--having count(*) >5
order by datepart(day, createdon), datepart(hh, createdon)
--order by count(*) desc

select datepart(hh, createdon) as hour,count(*) as perhour, count(*)/21.6666 as perday
from Applicationlog..log  (nolock)
where message like '%timeout%' and message like '%sql%' 
and createdon > getdate() - 30
and datepart(dw,createdon) between 2 and 6
group by datepart(hh, createdon)
--having count(*) >5
order by  datepart(hh, createdon)

select datepart(ww, createdon) as weeknumber,count(*) as perweek  --, count(*)/22 as perday
from Applicationlog..log  (nolock)
where message like '%timeout%' and message like '%sql%' 
and createdon > getdate() - (7*26)
--and datepart(dw,createdon) between 2 and 6
group by datepart(ww, createdon)
having count(*) >5
order by  datepart(ww, createdon)

select datepart(day, createdon) as day, count(*) as perday --, count(*)/21.6666 as perday
from Applicationlog..log (nolock)
where message like '%timeout%' and message like '%sql%' 
and createdon > getdate() - 30
and datepart(dw,createdon) between 2 and 6
group by datepart(day, createdon)
--having count(*) >5
order by datepart(day, createdon)
--order by datepart(day, createdon), datepart(hh, createdon)
--order by count(*) desc

select datepart(ww, createdon) as weeknumber,count(*) as perweek  --, count(*)/22 as perday
from Applicationlog..log  (nolock)
where message = 'LOGIN'
and createdon > getdate() - (7*26)
--and datepart(dw,createdon) between 2 and 6
group by datepart(ww, createdon)
having count(*) >5
order by  datepart(ww, createdon)