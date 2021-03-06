
Movie ( mID, title, year, director ) 
English: There is a movie with ID number mID, a title, a release year, and a director. 

Reviewer ( rID, name ) 
English: The reviewer with ID number rID has a certain name. 

Rating ( rID, mID, stars, ratingDate ) 
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 

--For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 
select name, title
from reviewer, movie
where rID in (select rID from rating R1 where exists (select rID from rating R2 
where R1.rID=R2.rID and R1.mID=R2.mID and R1.stars>R2.stars and R1.ratingDate>R2.ratingDate))
and mID in (select mID from rating R1 where exists (select rID from rating R2 
where R1.rID=R2.rID and R1.mID=R2.mID and R1.stars>R2.stars and R1.ratingDate>R2.ratingDate))

--For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. 
--Sort by movie title. 
select title,max(stars)
from Movie join Rating using(mID)
where stars is not NULL
group by title
order by title

select title,stars
from Movie join Rating using(mID)
where stars is not NULL and stars>=all(select stars from Rating R1, Rating R2 where R1.mID=R2.mID)
order by title



--For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. 
--Sort by rating spread from highest to lowest, then by movie title. 
select title,(max(stars)-min(stars))as spread
from movie join rating using(mid)
where stars is not NULL
group by title
order by spread desc,title

--Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. 
--(Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. 
--Don't just calculate the overall average rating before and after 1980.) 

select Before.avgrate-After.avgrate
from
(select avg(avgstars) as avgrate
from
(select mID,avg(stars) as avgstars
from rating
where stars is not NULL
group by mID)
where mID in (select mID from Movie where year<1980))AS Before,
(select avg(avgstars) as avgrate
from
(select mID,avg(stars) as avgstars
from rating
where stars is not NULL
group by mID)
where mID in (select mID from Movie where year>=1980))AS After


--Exercise 2
--For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. 
select name, title, stars
from (movie join rating using(mID)) join reviewer using(rID)
where name=director;

--Return all reviewer names and movie names together in a single list, alphabetized. 
--(Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) 
select names from
(
select distinct name as names from reviewer 
union 
select distinct title as names from movie 
)
order by names

--Find the titles of all movies not reviewed by Chris Jackson. 
--注意一个逻辑问题，不能直接选出name不等于Chrisjackson的title，因为可能这些电影也被别人点评了，但是不满足不被Chris点评的条件.
select distinct title
from movie left join (reviewer join rating using(rID)) using(mID)
where mID not in 
(select mID from movie left join (reviewer join rating using(rID)) using(mID) 
where name='Chris Jackson')

--For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. 
--Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. 
--For each pair, return the names in the pair in alphabetical order.
select distinct R1.name, R2.name
from (rating join reviewer using(rID)) as R1,(rating join reviewer using(rID)) as R2
where R1.rID<>R2.rID and R1.mID=R2.mID and R1.name<R2.name
order by R1.name
--names can also be sorted

--For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. 
select name, title, stars
from movie join (rating join reviewer on rating.rID=reviewer.rID) using(mID)
where stars=(select min(stars) from rating)


--List movie titles and average ratings, from highest-rated to lowest-rated. 
--If two or more movies have the same average rating, list them in alphabetical order. 
select title,avg(stars) as avgstars
from movie join rating using(mID)
where stars is not NULL
group by title
order by avgstars desc,title

--Find the names of all reviewers who have contributed three or more ratings. 
--(As an extra challenge, try writing the query without HAVING or without COUNT.) 
select name
from reviewer join rating using(rID)
group by name
having(count(*)>=3)

--GROUP BY and HAVING. The HAVING clause is tested after the GROUP BY.
-- You can test the aggregated values with a HAVING clause. 
--Show the total population of those continents with a total population of at least half a billion.


--Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name.
--Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) 
select title, director
from movie
where director in 
(select director 
from movie
group by director
having (count(*)>1))
order by director,title

--Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. 
--(Hint: This query is more difficult to write in SQLite than other systems; 
--you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 
select title,avgrate
from(
 select title,avgrate
  from(
   select avg(stars) as avgrate,title
    from movie join rating using(mID)
    group by title )
  group by title
  having avgrate=(select max(avgrate) 
  	              from (select avg(stars) as avgrate,title
                  from movie join rating using(mID)
                  group by title )))
--an alternative to this by using MySQL (note that on MySQL, should use join on command)
select title,avgrate
from (
  select title,avg(stars)as avgrate
  from movie join rating on movie.mid=rating.mid
  group by title) As M1
where M1.avgrate>=
  all(select avg(stars)as avgrate
  from movie join rating on movie.mid=rating.mid
  group by title)

--Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating.
--(Hint: This query may be more difficult to write in SQLite than other systems; 
--you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.) 
select title,avgrate
from(
 select title,avgrate
  from(
   select avg(stars) as avgrate,title
    from movie join rating using(mID)
    group by title )
  group by title
  having avgrate=(select min(avgrate) 
  	              from (select avg(stars) as avgrate,title
                  from movie join rating using(mID)
                  group by title )))

--For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, 
--and the value of that rating. Ignore movies whose director is NULL. 
select director,title,max(stars)
from movie join rating using(mID)
where director is not NULL 
group by director
--In this question, group by director it will return the one with the maximum rating??
--try PostgreSQL later
=======

Movie ( mID, title, year, director ) 
English: There is a movie with ID number mID, a title, a release year, and a director. 

Reviewer ( rID, name ) 
English: The reviewer with ID number rID has a certain name. 

Rating ( rID, mID, stars, ratingDate ) 
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 

--For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 
select name, title
from reviewer, movie
where rID in (select rID from rating R1 where exists (select rID from rating R2 
where R1.rID=R2.rID and R1.mID=R2.mID and R1.stars>R2.stars and R1.ratingDate>R2.ratingDate))
and mID in (select mID from rating R1 where exists (select rID from rating R2 
where R1.rID=R2.rID and R1.mID=R2.mID and R1.stars>R2.stars and R1.ratingDate>R2.ratingDate))

--For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. 
--Sort by movie title. 
select title,max(stars)
from Movie join Rating using(mID)
where stars is not NULL
group by title
order by title

select title,stars
from Movie join Rating using(mID)
where stars is not NULL and stars>=all(select stars from Rating R1, Rating R2 where R1.mID=R2.mID)
order by title



--For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. 
--Sort by rating spread from highest to lowest, then by movie title. 
select title,(max(stars)-min(stars))as spread
from movie join rating using(mid)
where stars is not NULL
group by title
order by spread desc,title

--Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. 
--(Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. 
--Don't just calculate the overall average rating before and after 1980.) 

select Before.avgrate-After.avgrate
from
(select avg(avgstars) as avgrate
from
(select mID,avg(stars) as avgstars
from rating
where stars is not NULL
group by mID)
where mID in (select mID from Movie where year<1980))AS Before,
(select avg(avgstars) as avgrate
from
(select mID,avg(stars) as avgstars
from rating
where stars is not NULL
group by mID)
where mID in (select mID from Movie where year>=1980))AS After


--Exercise 2
--For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. 
select name, title, stars
from (movie join rating using(mID)) join reviewer using(rID)
where name=director;

--Return all reviewer names and movie names together in a single list, alphabetized. 
--(Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) 
select names from
(
select distinct name as names from reviewer 
union 
select distinct title as names from movie 
)
order by names

--Find the titles of all movies not reviewed by Chris Jackson. 
--注意一个逻辑问题，不能直接选出name不等于Chrisjackson的title，因为可能这些电影也被别人点评了，但是不满足不被Chris点评的条件.
select distinct title
from movie left join (reviewer join rating using(rID)) using(mID)
where mID not in 
(select mID from movie left join (reviewer join rating using(rID)) using(mID) 
where name='Chris Jackson')

--For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. 
--Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. 
--For each pair, return the names in the pair in alphabetical order.
select distinct R1.name, R2.name
from (rating join reviewer using(rID)) as R1,(rating join reviewer using(rID)) as R2
where R1.rID<>R2.rID and R1.mID=R2.mID and R1.name<R2.name
order by R1.name
--names can also be sorted

--For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. 
select name, title, stars
from movie join (rating join reviewer on rating.rID=reviewer.rID) using(mID)
where stars=(select min(stars) from rating)


--List movie titles and average ratings, from highest-rated to lowest-rated. 
--If two or more movies have the same average rating, list them in alphabetical order. 
select title,avg(stars) as avgstars
from movie join rating using(mID)
where stars is not NULL
group by title
order by avgstars desc,title

--Find the names of all reviewers who have contributed three or more ratings. 
--(As an extra challenge, try writing the query without HAVING or without COUNT.) 
select name
from reviewer join rating using(rID)
group by name
having(count(*)>=3)


>>>>>>> d18bf3266e759f3ab0c06dab2a24d5af56c0d025:StanfordExercise1.sql
=======
Movie ( mID, title, year, director ) 
English: There is a movie with ID number mID, a title, a release year, and a director. 

Reviewer ( rID, name ) 
English: The reviewer with ID number rID has a certain name. 

Rating ( rID, mID, stars, ratingDate ) 
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 

--For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 
select name, title
from reviewer, movie
where rID in (select rID from rating R1 where exists (select rID from rating R2 
where R1.rID=R2.rID and R1.mID=R2.mID and R1.stars>R2.stars and R1.ratingDate>R2.ratingDate))
and mID in (select mID from rating R1 where exists (select rID from rating R2 
where R1.rID=R2.rID and R1.mID=R2.mID and R1.stars>R2.stars and R1.ratingDate>R2.ratingDate))

--For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. 
--Sort by movie title. 
select title,max(stars)
from Movie join Rating using(mID)
where stars is not NULL
group by title
order by title

select title,stars
from Movie join Rating using(mID)
where stars is not NULL and stars>=all(select stars from Rating R1, Rating R2 where R1.mID=R2.mID)
order by title



--For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. 
--Sort by rating spread from highest to lowest, then by movie title. 
select title,(max(stars)-min(stars))as spread
from movie join rating using(mid)
where stars is not NULL
group by title
order by spread desc,title

--Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. 
--(Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. 
--Don't just calculate the overall average rating before and after 1980.) 

select Before.avgrate-After.avgrate
from
(select avg(avgstars) as avgrate
from
(select mID,avg(stars) as avgstars
from rating
where stars is not NULL
group by mID)
where mID in (select mID from Movie where year<1980))AS Before,
(select avg(avgstars) as avgrate
from
(select mID,avg(stars) as avgstars
from rating
where stars is not NULL
group by mID)
where mID in (select mID from Movie where year>=1980))AS After


--Exercise 2
--For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. 
select name, title, stars
from (movie join rating using(mID)) join reviewer using(rID)
where name=director;

--Return all reviewer names and movie names together in a single list, alphabetized. 
--(Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) 
select names from
(
select distinct name as names from reviewer 
union 
select distinct title as names from movie 
)
order by names

--Find the titles of all movies not reviewed by Chris Jackson. 
--注意一个逻辑问题，不能直接选出name不等于Chrisjackson的title，因为可能这些电影也被别人点评了，但是不满足不被Chris点评的条件.
select distinct title
from movie left join (reviewer join rating using(rID)) using(mID)
where mID not in 
(select mID from movie left join (reviewer join rating using(rID)) using(mID) 
where name='Chris Jackson')

--For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. 
--Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. 
--For each pair, return the names in the pair in alphabetical order.
select distinct R1.name, R2.name
from (rating join reviewer using(rID)) as R1,(rating join reviewer using(rID)) as R2
where R1.rID<>R2.rID and R1.mID=R2.mID and R1.name<R2.name
order by R1.name
--names can also be sorted

--For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. 
select name, title, stars
from movie join (rating join reviewer on rating.rID=reviewer.rID) using(mID)
where stars=(select min(stars) from rating)


--List movie titles and average ratings, from highest-rated to lowest-rated. 
--If two or more movies have the same average rating, list them in alphabetical order. 
select title,avg(stars) as avgstars
from movie join rating using(mID)
where stars is not NULL
group by title
order by avgstars desc,title

--Find the names of all reviewers who have contributed three or more ratings. 
--(As an extra challenge, try writing the query without HAVING or without COUNT.) 
select name
from reviewer join rating using(rID)
group by name
having(count(*)>=3)

--Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name.
--Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) 
select title, director
from movie
where director in 
(select director 
from movie
group by director
having (count(*)>1))
order by director,title

--Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. 
--(Hint: This query is more difficult to write in SQLite than other systems; 
--you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 
select title,avgrate
from(
 select title,avgrate
  from(
   select avg(stars) as avgrate,title
    from movie join rating using(mID)
    group by title )
  group by title
  having avgrate=(select max(avgrate) 
  	              from (select avg(stars) as avgrate,title
                  from movie join rating using(mID)
                  group by title )))
--an alternative to this by using MySQL (note that on MySQL, should use join on command)
select title,avgrate
from (
  select title,avg(stars)as avgrate
  from movie join rating on movie.mid=rating.mid
  group by title) As M1
where M1.avgrate>=
  all(select avg(stars)as avgrate
  from movie join rating on movie.mid=rating.mid
  group by title)

--Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating.
--(Hint: This query may be more difficult to write in SQLite than other systems; 
--you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.) 
select title,avgrate
from(
 select title,avgrate
  from(
   select avg(stars) as avgrate,title
    from movie join rating using(mID)
    group by title )
  group by title
  having avgrate=(select min(avgrate) 
  	              from (select avg(stars) as avgrate,title
                  from movie join rating using(mID)
                  group by title )))

--For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, 
--and the value of that rating. Ignore movies whose director is NULL. 
select director,title,max(stars)
from movie join rating using(mID)
where director is not NULL 
group by director
--In this question, group by director it will return the one with the maximum rating??
--try PostgreSQL later
=======

Movie ( mID, title, year, director ) 
English: There is a movie with ID number mID, a title, a release year, and a director. 

Reviewer ( rID, name ) 
English: The reviewer with ID number rID has a certain name. 

Rating ( rID, mID, stars, ratingDate ) 
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 

--For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 
select name, title
from reviewer, movie
where rID in (select rID from rating R1 where exists (select rID from rating R2 
where R1.rID=R2.rID and R1.mID=R2.mID and R1.stars>R2.stars and R1.ratingDate>R2.ratingDate))
and mID in (select mID from rating R1 where exists (select rID from rating R2 
where R1.rID=R2.rID and R1.mID=R2.mID and R1.stars>R2.stars and R1.ratingDate>R2.ratingDate))

--For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. 
--Sort by movie title. 
select title,max(stars)
from Movie join Rating using(mID)
where stars is not NULL
group by title
order by title

select title,stars
from Movie join Rating using(mID)
where stars is not NULL and stars>=all(select stars from Rating R1, Rating R2 where R1.mID=R2.mID)
order by title



--For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. 
--Sort by rating spread from highest to lowest, then by movie title. 
select title,(max(stars)-min(stars))as spread
from movie join rating using(mid)
where stars is not NULL
group by title
order by spread desc,title

--Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. 
--(Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. 
--Don't just calculate the overall average rating before and after 1980.) 

select Before.avgrate-After.avgrate
from
(select avg(avgstars) as avgrate
from
(select mID,avg(stars) as avgstars
from rating
where stars is not NULL
group by mID)
where mID in (select mID from Movie where year<1980))AS Before,
(select avg(avgstars) as avgrate
from
(select mID,avg(stars) as avgstars
from rating
where stars is not NULL
group by mID)
where mID in (select mID from Movie where year>=1980))AS After


--Exercise 2
--For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. 
select name, title, stars
from (movie join rating using(mID)) join reviewer using(rID)
where name=director;

--Return all reviewer names and movie names together in a single list, alphabetized. 
--(Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) 
select names from
(
select distinct name as names from reviewer 
union 
select distinct title as names from movie 
)
order by names

--Find the titles of all movies not reviewed by Chris Jackson. 
--注意一个逻辑问题，不能直接选出name不等于Chrisjackson的title，因为可能这些电影也被别人点评了，但是不满足不被Chris点评的条件.
select distinct title
from movie left join (reviewer join rating using(rID)) using(mID)
where mID not in 
(select mID from movie left join (reviewer join rating using(rID)) using(mID) 
where name='Chris Jackson')

--For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. 
--Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. 
--For each pair, return the names in the pair in alphabetical order.
select distinct R1.name, R2.name
from (rating join reviewer using(rID)) as R1,(rating join reviewer using(rID)) as R2
where R1.rID<>R2.rID and R1.mID=R2.mID and R1.name<R2.name
order by R1.name
--names can also be sorted

--For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. 
select name, title, stars
from movie join (rating join reviewer on rating.rID=reviewer.rID) using(mID)
where stars=(select min(stars) from rating)


--List movie titles and average ratings, from highest-rated to lowest-rated. 
--If two or more movies have the same average rating, list them in alphabetical order. 
select title,avg(stars) as avgstars
from movie join rating using(mID)
where stars is not NULL
group by title
order by avgstars desc,title

--Find the names of all reviewers who have contributed three or more ratings. 
--(As an extra challenge, try writing the query without HAVING or without COUNT.) 
select name
from reviewer join rating using(rID)
group by name
having(count(*)>=3)

