USE [master]
GO

/****** Object:  Login [HDI\Alex.State]    Script Date: 12/1/2011 4:36:00 PM ******/
CREATE LOGIN [HDI\Alex.State] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\alicia.luke]    Script Date: 12/1/2011 4:36:00 PM ******/
CREATE LOGIN [HDI\alicia.luke] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\amelita.herrera]    Script Date: 12/1/2011 4:36:00 PM ******/
CREATE LOGIN [HDI\amelita.herrera] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\amesha.hidalgo]    Script Date: 12/1/2011 4:36:00 PM ******/
CREATE LOGIN [HDI\amesha.hidalgo] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\anthony.bronsdon]    Script Date: 12/1/2011 4:36:00 PM ******/
CREATE LOGIN [HDI\anthony.bronsdon] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\ashraf.younis]    Script Date: 12/1/2011 4:36:00 PM ******/
CREATE LOGIN [HDI\ashraf.younis] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\Babita.Rajasekaran]    Script Date: 12/1/2011 4:36:00 PM ******/
CREATE LOGIN [HDI\Babita.Rajasekaran] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\brian.reed]    Script Date: 12/1/2011 4:36:00 PM ******/
CREATE LOGIN [HDI\brian.reed] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\brian.troch]    Script Date: 12/1/2011 4:36:00 PM ******/
CREATE LOGIN [HDI\brian.troch] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\chad.barton]    Script Date: 12/1/2011 4:36:00 PM ******/
CREATE LOGIN [HDI\chad.barton] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\christopher.luke]    Script Date: 12/1/2011 4:36:00 PM ******/
CREATE LOGIN [HDI\christopher.luke] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\ellen.lee]    Script Date: 12/1/2011 4:36:00 PM ******/
CREATE LOGIN [HDI\ellen.lee] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\harrison.mayo]    Script Date: 12/1/2011 4:36:00 PM ******/
CREATE LOGIN [HDI\harrison.mayo] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\isaac.agan]    Script Date: 12/1/2011 4:36:00 PM ******/
CREATE LOGIN [HDI\isaac.agan] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\jennie.walker]    Script Date: 12/1/2011 4:36:00 PM ******/
CREATE LOGIN [HDI\jennie.walker] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\jennifer.hogan]    Script Date: 12/1/2011 4:36:00 PM ******/
CREATE LOGIN [HDI\jennifer.hogan] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\john.morgan]    Script Date: 12/1/2011 4:36:00 PM ******/
CREATE LOGIN [HDI\john.morgan] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\kathi.marin]    Script Date: 12/1/2011 4:36:00 PM ******/
CREATE LOGIN [HDI\kathi.marin] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\Alex.State]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\alicia.luke]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\amelita.herrera]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\amesha.hidalgo]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\anthony.bronsdon]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\Babita.Rajasekaran]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\brian.reed]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\brian.troch]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\chad.barton]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\christopher.luke]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\ellen.lee]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\harrison.mayo]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\isaac.agan]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\jennie.walker]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\jennifer.hogan]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\john.morgan]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\kathi.marin]
GO


USE [master]
GO

/****** Object:  Login [HDI\LAS - IT SD - DBA]    Script Date: 12/1/2011 4:36:40 PM ******/
CREATE LOGIN [HDI\LAS - IT SD - DBA] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\leeann.zukowski]    Script Date: 12/1/2011 4:36:40 PM ******/
CREATE LOGIN [HDI\leeann.zukowski] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\m.evansparchment]    Script Date: 12/1/2011 4:36:40 PM ******/
CREATE LOGIN [HDI\m.evansparchment] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\melinda.marszalek]    Script Date: 12/1/2011 4:36:40 PM ******/
CREATE LOGIN [HDI\melinda.marszalek] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\monica.brown]    Script Date: 12/1/2011 4:36:40 PM ******/
CREATE LOGIN [HDI\monica.brown] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\nathan.heath]    Script Date: 12/1/2011 4:36:40 PM ******/
CREATE LOGIN [HDI\nathan.heath] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\roquesa.meijer]    Script Date: 12/1/2011 4:36:40 PM ******/
CREATE LOGIN [HDI\roquesa.meijer] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\rosendo.mercado]    Script Date: 12/1/2011 4:36:40 PM ******/
CREATE LOGIN [HDI\rosendo.mercado] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\siqi.tan]    Script Date: 12/1/2011 4:36:40 PM ******/
CREATE LOGIN [HDI\siqi.tan] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\sonia.webb]    Script Date: 12/1/2011 4:36:40 PM ******/
CREATE LOGIN [HDI\sonia.webb] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\stephanie.gavin]    Script Date: 12/1/2011 4:36:40 PM ******/
CREATE LOGIN [HDI\stephanie.gavin] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\thomas.nelson]    Script Date: 12/1/2011 4:36:40 PM ******/
CREATE LOGIN [HDI\thomas.nelson] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [HDI\V.Naraharisetti]    Script Date: 12/1/2011 4:36:40 PM ******/
CREATE LOGIN [HDI\V.Naraharisetti] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\LAS - IT SD - DBA]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\leeann.zukowski]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\m.evansparchment]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\melinda.marszalek]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\monica.brown]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\nathan.heath]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\roquesa.meijer]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\rosendo.mercado]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\siqi.tan]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\sonia.webb]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\stephanie.gavin]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\thomas.nelson]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [HDI\V.Naraharisetti]
GO

