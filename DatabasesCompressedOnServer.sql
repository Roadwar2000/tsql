use master
go
CREATE TABLE [dbo].[DBsWithFeatures](
	[feature_name] [nvarchar](4000) NULL,
	[feature_id] [int] NOT NULL,
	[db_name] [sysname] NULL
) ON [PRIMARY]
GO
exec sp_msforeachdb 
'use [?];
INSERT master.dbo.DBsWithFeatures (feature_name, feature_id, db_name)
select *,(select name from sys.databases where database_id=db_id()) as db_name
from sys.dm_db_persisted_sku_features
where feature_name = ''Compression'';
'
select *
from master.dbo.DBsWithFeatures
drop table master.dbo.DBsWithFeatures