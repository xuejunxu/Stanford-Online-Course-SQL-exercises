Movie ( mID, title, year, director ) 
English: There is a movie with ID number mID, a title, a release year, and a director. 

Reviewer ( rID, name ) 
English: The reviewer with ID number rID has a certain name. 

Rating ( rID, mID, stars, ratingDate ) 
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 

Social Media Modification Practice

--1.Add the reviewer Roger Ebert to your database, with an rID of 209. 
insert into reviewer
values(209, 'Roger Ebert')

--2.Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL. 
insert into Rating
select reviewer.rid, movie.mid, 5, NULL
from reviewer,movie, Rating
where reviewer.name=='James Cameron' and reviewer.rid=Rating.rid and movie.mid in (select mID from Movie)

--3.For all movies that have an average rating of 4 stars or higher, add 25 to the release year. 
--(Update the existing tuples; don't insert new tuples.) 
update Movie
set year=year+25
where mid in 
(select mid from
 (select avg(stars) as avgstar, movie.mid from rating, movie where movie.mid=rating.mid group by rating.mid having avgstar>=4))

--4.Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars. 
delete from Rating
where mid in (select mid from movie where year<=1970 or year >=2000)
and stars<4
