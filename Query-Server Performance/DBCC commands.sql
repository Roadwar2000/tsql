dbcc help(tracestatus)
dbcc show_statistics
dbcc sqlperf(logspace) -- % of disk space used by transaction log files
dbcc help(sqlperf)
dbcc help(show_statistics)
select * from sys.dm_os_wait_stats
dbcc help("?")
dbcc sqlperf("sys.dm_os_wait_stats", clear) -- This happens when restarting the instance anyway

-- Do in test env
dbcc dropcleanbuffers
dbcc freeproccache -- ALL databases
dbcc flushprocindb -- Or just do one database

set statistics io on
sp_helpindex "audit"

dbcc checkconstraints with all_constraints

dbcc ind
dbcc page --  must use dbcc traceon(3604) first
dbcc dbinfo
dbcc loginfo ("ClientArchive") -- How many of VLFs do I have for a database?

dbcc checkdb

/* LittleKendra.com */