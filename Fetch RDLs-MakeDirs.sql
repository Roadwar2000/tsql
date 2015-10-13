declare @s NVARCHAR(MAX), @path NVARCHAR(MAX), @p varchar(500), @ID INT

declare q CURSOR FOR 
SELECT L,PATH --, ID
FROM RDLs

open q

FETCH NEXT FROM q INTO @s, @path --, @ID
WHILE @@FETCH_STATUS = 0 
BEGIN
    SET @p = cast('MD "X:\RDLs'+REPLACE(@path, '/','\')+'"' as varchar(max))
	set @p = left(@p, len(@p)-charindex('\',reverse(@p)))
	--print @id
	print @p
	print @s

    exec xp_cmdshell @p
	--EXEC SP_EXECUTESQL @s
	FETCH NEXT FROM q INTO @s,@path -- , @ID
END

close q
DEALLOCATE q

--sp_configure 'xp_cmdshell',1
--reconfigure