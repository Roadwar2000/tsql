select *
FROM master.sys.databases
where database_id>4 and name <> 'distribution'