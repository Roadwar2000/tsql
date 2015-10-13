exec sp_msforeachdb 'use [?];
declare @tc bigint, @rc bigint;
select @tc=count(1) , @rc=sum(rowcnt)
from (
SELECT object_name(id) as objname,rowcnt
FROM sysindexes
WHERE indid IN (1,0) AND OBJECTPROPERTY(id, ''IsUserTable'') = 1
) t;
print cast(@tc as varchar(15)) + '',''+cast(@rc as varchar(15));'