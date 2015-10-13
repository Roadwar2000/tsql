USE [HUMANA2_MASTER]
GO
DECLARE @newsize int
set @newsize = 638100

while @newsize > 500000
BEGIN
   raiserror ('new size is %d',0,0,@newsize)
   DBCC SHRINKFILE (N'HUMANA2_MASTER' , 638100) --@newsize)
   set @newsize = @newsize - 100
END
GO
