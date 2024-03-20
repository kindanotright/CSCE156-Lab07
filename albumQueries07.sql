-- Computer Science II
-- Lab 7.0 - Structured Query Language I
-- Queries
--
-- Name(s): Megan Bogatz
-- Date: 2024-03-06
-- 
--
-- For each question, write an SQL query to get the specified result. You
-- are highly encouraged to use a GUI SQL tool such as MySQL Workbench and
-- keep track of your queries in an SQL script so that lab instructors can
-- verify your work. If you do, write your queries in the script file
-- provided rather than hand-writing your queries here.

-- Simple Queries 
-- --------------

-- 1. List all albums in the database.
Select * from Album;

-- 2. List all albums in the database from newest to oldest.
Select * from Album Order by year Asc;

-- 3. List all bands in the database that begin with "The".
Select * from Band where name like 'The%';

-- 4. List all songs in the database in alphabetic order.
Select * from Song Order by title Asc;

-- 5. Write a query that gives just the albumId of the album "Nevermind".
Select albumId from Album where title like 'Nevermind';


-- Simple Aggregate Queries 
-- ------------------------

-- 6. Write a query to determine how many musicians are in the database.
Select count(*) from Musician;

-- 7. Write a (nested) query to list the oldest album(s) in the database.
Select * from Album where year = (Select min(year) from Album);

-- 8. Write a query to find the total running time (in seconds) of all 
--    tracks on the album *Rain Dogs* by Tom Waits
Select sum(trackLength) from Album join AlbumSong on Album.albumId = AlbumSong.albumId where title like 'Rain Dogs';




-- Join Queries 
-- ------------

-- 9. Write a query list all albums in the database along with the album's
--    band, but only include the album title, year and band name.
Select * from Album;
Select title, year, name from Album join Band on Album.bandId = Band.bandId;


-- 10. Write a query that lists all albums and all tracks on the albums 
--     for the band Nirvana.
SELECT Album.title AS AlbumTitle, Song.title AS TrackTitle, Band.name
FROM Album
JOIN AlbumSong ON Album.albumId = AlbumSong.albumId
JOIN Song ON AlbumSong.songId = Song.songId
JOIN Band ON Album.bandId = Band.bandId
WHERE Band.name = 'Nirvana';


-- 11. Write a query that list all bands along with all their albums in 
--     the database *even if they do not have any*.
SELECT Band.name AS BandName, Album.title AS AlbumTitle, COALESCE(Song.title, 'No tracks') AS TrackTitle
FROM Band
LEFT JOIN Album ON Band.bandId = Album.bandId
LEFT JOIN AlbumSong ON Album.albumId = AlbumSong.albumId
LEFT JOIN Song ON AlbumSong.songId = Song.songId
ORDER BY BandName ASC, AlbumTitle ASC, TrackTitle ASC;


-- Grouped Join Queries 
-- --------------------

-- 12. Write a query list all bands along with a *count* of how many albums
--     they have in the database (as you saw in the previous query, some should
--     have zero).
SELECT Band.name AS BandName, COUNT(Album.albumId) AS AlbumCount
FROM Band
LEFT JOIN Album ON Band.bandId = Album.bandId
GROUP BY Band.bandId, Band.name
ORDER BY BandName ASC;


-- 13. Write a query that lists all albums in the database along with the
--     number of tracks on them.
SELECT Album.title, count(trackNumber) FROM Album 
JOIN AlbumSong on Album.albumId = AlbumSong.albumId
GROUP BY Album.title Asc;


-- 14. Write the same query, but limit it to albums which have 12 or more
--     tracks on them.
SELECT Album.title, count(trackNumber) FROM Album 
JOIN AlbumSong on Album.albumId = AlbumSong.albumId
GROUP BY Album.albumId, Album.title
HAVING count(trackNumber) >= 12
ORDER BY Album.title ASC;


-- 15. Write a query to find all musicians that are not in any bands.
SELECT Musician.firstName, Musician.lastName, Musician.musicianId
FROM Musician
LEFT JOIN BandMember ON Musician.musicianId = BandMember.musicianId
WHERE BandMember.bandId IS NULL
ORDER BY Musician.musicianId ASC;


-- 16. Write a query to find all musicians that are in more than one band.
SELECT * FROM BandMember
Group by musicianId ASC
HAVING count(musicianId) > 1;
-- return all the info on the band member

SELECT BandMember.musicianId, Musician.firstName, Musician.lastName, COUNT(BandMember.bandId)
FROM Musician
JOIN BandMember ON Musician.musicianId = BandMember.musicianId
GROUP BY Musician.musicianId
HAVING Count(BandMember.bandId) > 1;
-- just returns musician ID, full name and number of bands they are in