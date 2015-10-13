:CONNECT dcsqlprd107

USE AppProductErrors

SELECT TOP 10 le.RequestDate, *
FROM dbo.LogException AS le WITH (NOLOCK)
WHERE le.[Message] LIKE '%dcsqlprd501.usweb.costar.local%' 
AND le.[Message] LIKE '%Could not create connection to the brokered database%'
ORDER BY le.RequestDate DESC
