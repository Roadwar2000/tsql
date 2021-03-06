-- Dropping the transactional articles
use [CDWINNT]
exec sp_dropsubscription @publication = N'HDIRACFTP_CDWINNT', @article = N'HDIRACFTPV4200PRE_R', @subscriber = N'all', @destination_db = N'all'
GO
use [CDWINNT]
exec sp_droparticle @publication = N'HDIRACFTP_CDWINNT', @article = N'HDIRACFTPV4200PRE_R', @force_invalidate_snapshot = 1
GO
use [CDWINNT]
exec sp_dropsubscription @publication = N'HDIRACFTP_CDWINNT', @article = N'HDIRACFTPV4200PRE_S', @subscriber = N'all', @destination_db = N'all'
GO
use [CDWINNT]
exec sp_droparticle @publication = N'HDIRACFTP_CDWINNT', @article = N'HDIRACFTPV4200PRE_S', @force_invalidate_snapshot = 1
GO
use [CDWINNT]
exec sp_dropsubscription @publication = N'HDIRACFTP_CDWINNT', @article = N'HDIRACFTPV4200STAT', @subscriber = N'all', @destination_db = N'all'
GO
use [CDWINNT]
exec sp_droparticle @publication = N'HDIRACFTP_CDWINNT', @article = N'HDIRACFTPV4200STAT', @force_invalidate_snapshot = 1
GO
use [CDWINNT]
exec sp_dropsubscription @publication = N'HDIRACFTP_CDWINNT', @article = N'HDIRACFTPV4200TCQ', @subscriber = N'all', @destination_db = N'all'
GO
use [CDWINNT]
exec sp_droparticle @publication = N'HDIRACFTP_CDWINNT', @article = N'HDIRACFTPV4200TCQ', @force_invalidate_snapshot = 1
GO
use [CDWINNT]
exec sp_dropsubscription @publication = N'HDIRACFTP_CDWINNT', @article = N'usp_View_Stats_table', @subscriber = N'all', @destination_db = N'all'
GO
use [CDWINNT]
exec sp_droparticle @publication = N'HDIRACFTP_CDWINNT', @article = N'usp_View_Stats_table', @force_invalidate_snapshot = 1
GO

-- Dropping the transactional publication
use [CDWINNT]
exec sp_droppublication @publication = N'HDIRACFTP_CDWINNT'
GO

