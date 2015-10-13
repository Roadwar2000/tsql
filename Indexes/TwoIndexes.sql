use [HDIEventLog]
go

CREATE CLUSTERED INDEX [_dta_index_ChangeLog_c_50_2089058478__K2_K1] ON [dbo].[ChangeLog] 
(
	[ServerName] ASC,
	[LogId] ASC
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_2089058478_2_1] ON [dbo].[ChangeLog]([ServerName], [LogId])
go

