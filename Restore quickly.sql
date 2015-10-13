--3 files
EXECUTE master..sqlbackup '-SQL "RESTORE DATABASE [ProductionTemp] FROM DISK = ''X:\LogShipping\FULL_(local)_ProductionTemp.sqb'' WITH PASSWORD = ''3NcryPt(6)n'', STANDBY = ''X:\CLCMSDRSQL_DailyBackups\Undo_ProductionTemp.dat'', MOVE ''ProductionTemp'' TO ''K:\DataFiles\ProductionTemp.mdf'', MOVE ''ProductionTempindexes'' TO ''J:\IndexFiles\ProductionTempIndexes.ndf'', MOVE ''ProductionTemp_log'' TO ''H:\LogFiles\ProductionTemp_log.ldf''"'


--2 files
EXECUTE master..sqlbackup '-SQL "RESTORE DATABASE [ProviderMaster] FROM DISK = ''X:\LogShipping\FULL_(local)_ProviderMaster.sqb'' WITH PASSWORD = ''3NcryPt(6)n'', STANDBY = ''X:\CLCMSDRSQL_DailyBackups\Undo_ProviderMaster.dat'', MOVE ''ProviderMaster'' TO ''K:\DataFiles\ProviderMaster.mdf'', MOVE ''ProviderMaster_log'' TO ''H:\LogFiles\ProviderMaster_log.ldf''"'


--EXECUTE master..sqlbackup '-SQL "RESTORE DATABASE [ProviderPortal] FROM DISK = ''X:\LogShipping\FULL_(local)_ProviderPortal.sqb'' WITH PASSWORD = ''3NcryPt(6)n'', STANDBY = ''X:\CLCMSDRSQL_DailyBackups\Undo_ProviderPortal.dat'', MOVE ''ProviderPortal_Prod'' TO ''K:\DataFiles\ProviderPortal.mdf'', MOVE ''ProviderPortal_Prod_log'' TO ''H:\LogFiles\ProviderPortal_log.ldf''"'
