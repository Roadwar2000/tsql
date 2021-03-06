SELECT *
FROM dbo.Movies M
JOIN Genres G on G.GenreId = M.MovieGenreId
-- 5 rows
------------------------------------------------------------------
SELECT *
FROM dbo.Movies M
LEFT OUTER JOIN Genres G on G.GenreId = M.MovieGenreId
-- 6 rows
----------------------------------------------------------------
SELECT *
FROM dbo.Movies M
RIGHT OUTER JOIN Genres G on G.GenreId = M.MovieGenreId
-- 9 rows
------------------------------------------------------------------
SELECT *
FROM dbo.Movies M
FULL JOIN Genres G on G.GenreId = M.MovieGenreId
-- 10 rows
------------------------------------------------------------------
SELECT *
FROM dbo.Movies
CROSS JOIN Genres
-- 42 rows