backup log pharmacyproduction with truncatE_only
go
backup log firstdata with truncatE_only
go
backup log coventry with truncatE_only
go
USE [PharmacyProduction]
GO
DBCC SHRINKFILE (N'PharmacyProduction_log' , 0)
GO
USE [firstdata]
GO
DBCC SHRINKFILE (N'firstdata_log' , 0)
GO
USE [coventry]
GO
DBCC SHRINKFILE (N'coventry2_log' , 0)
GO
