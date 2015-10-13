--sp_msforeachdb 'use [?]; GRANT SHOWPLAN TO [HDI\NPB - IT - SQL Production]; GRANT SHOWPLAN TO [HDI\LAS - IT SD - Tier 2 SQL Production]; GRANT SHOWPLAN TO [HDI\LAS - IT SD - Tier 2 SQL Analysts]; GRANT SHOWPLAN TO [HDI\LAS - Data Analytics - Production]'
--GO
--sp_helpindex "detail"

--dbcc show_statistics ('detail','ix_patientid') with HISTOGRAM
--dbcc help(show_statistics)

sp_msforeachdb 'use [?]; 
GRANT SHOWPLAN TO [HDI\NPB - IT - SQL Production]; 
GRANT SHOWPLAN TO [HDI\LAS - Data Analytics - Production]
GRANT SHOWPLAN TO [HDI\LAS - IT CMS - Tier 2 SQL Analysts]; 
GRANT SHOWPLAN TO [HDI\LAS - IT CMS - Tier 3 SQL Analysts]; 
'
GO
use [master]
GO
REVOKE SHOWPLAN TO [HDI\NPB - IT - SQL Production]; 
REVOKE SHOWPLAN TO [HDI\LAS - Data Analytics - Production]
REVOKE SHOWPLAN TO [HDI\LAS - IT CMS - Tier 2 SQL Analysts]; 
REVOKE SHOWPLAN TO [HDI\LAS - IT CMS - Tier 3 SQL Analysts]; 
GO
use [msdb]
GO
REVOKE SHOWPLAN TO [HDI\NPB - IT - SQL Production]; 
REVOKE SHOWPLAN TO [HDI\LAS - Data Analytics - Production]
REVOKE SHOWPLAN TO [HDI\LAS - IT CMS - Tier 2 SQL Analysts]; 
REVOKE SHOWPLAN TO [HDI\LAS - IT CMS - Tier 3 SQL Analysts]; 
GO
use [tempdb]
GO
REVOKE SHOWPLAN TO [HDI\NPB - IT - SQL Production]; 
REVOKE SHOWPLAN TO [HDI\LAS - Data Analytics - Production]
REVOKE SHOWPLAN TO [HDI\LAS - IT CMS - Tier 2 SQL Analysts]; 
REVOKE SHOWPLAN TO [HDI\LAS - IT CMS - Tier 3 SQL Analysts]; 


use [DISTRIBUTION]
GO
REVOKE SHOWPLAN TO [HDI\NPB - IT - SQL Production]; 
REVOKE SHOWPLAN TO [HDI\LAS - Data Analytics - Production]
REVOKE SHOWPLAN TO [HDI\LAS - IT CMS - Tier 2 SQL Analysts]; 
REVOKE SHOWPLAN TO [HDI\LAS - IT CMS - Tier 3 SQL Analysts]; 