declare @s NVARCHAR(MAX)

declare q CURSOR FOR 
SELECT L
FROM RDLs

open q

FETCH NEXT FROM q INTO @s
WHILE @@FETCH_STATUS = 0 
BEGIN
	EXEC SP_EXECUTESQL @s
	FETCH NEXT FROM q INTO @s
END

close q
DEALLOCATE q