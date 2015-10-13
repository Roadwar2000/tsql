select auth_scheme,ServerProperty('ComputerNamePhysicalNetBIOS') from sys.dm_exec_connections where session_id=@@spid
--and auth_scheme = 'NTLM'
--exec sp_helpdb 'distribution'
