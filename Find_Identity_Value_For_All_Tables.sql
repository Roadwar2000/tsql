set nocount on
declare @tablename nvarchar(100), @sql nvarchar(500), @maxident bigint, @ID_Column nvarchar(30)
DECLARE tablescur cursor for
SELECT SCHEMA_NAME(t.schema_id)+'.'+t.name AS table_name
FROM sys.tables AS t INNER JOIN
sys.sysindexes AS i ON t.object_id = i.id AND i.indid < 2
where t.type = 'U' and t.is_ms_shipped = 0

open tablescur
fetch next from tablescur
into @tableName

while @@FETCH_STATUS=0
BEGIN

	IF objectproperty(OBJECT_ID(@tablename), 'TableHasIdentity') =1
	BEGIN
		set @ID_Column='id'
		--select @ID_Column = name
		--from sys.columns
		--where column_id=1 and object_id = OBJECT_ID(@tablename)

		set @sql = N'select @MaxIdentOut=max('+@ID_Column+') from '+@tableName
		exec sp_executesql @sql, N'@maxidentout bigint output', @maxidentOut = @MaxIdent OUTPUT

		print @tablename+' '+cast(@Maxident as varchar(20))
	END

	fetch next from tablescur
	into @tableName
END

close tablescur
deallocate tablescur



