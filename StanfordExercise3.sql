Highschooler ( ID, name, grade ) 
English: There is a high school student with unique ID and a given first name in a certain grade. 

Friend ( ID1, ID2 ) 
English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123). 

Likes ( ID1, ID2 ) 
English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. 


--1.Find the names of all students who are friends with someone named Gabriel. 

select distinct name 
from highschooler join friend 
on highschooler.id=friend.id1
where id2 in(select id from highschooler join friend on highschooler.id=friend.id1 where name='Gabriel')

--2. For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. 
select Liker.name,Liker.grade,Likee.name,Likee.grade
from (likes join highschooler on likes.id1=highschooler.id) As Liker,
(likes join highschooler on likes.id2=highschooler.id) As Likee
where Liker.id1=Likee.id1 and Liker.id2=Likee.id2 and Liker.grade-2>=Likee.grade

--3.For every pair of students who both like each other, return the name and grade of both students. 
--Include each pair only once, with the two names in alphabetical order. 
select h1.name, h1.grade, h2.name, h2.grade
from Likes L1, Likes L2, highschooler H1, Highschooler H2
where l1.id1=l2.id2 and l1.id2=l2.id1 and l1.id1=h1.id and l1.id2=h2.id and h1.name<h2.name
order by h1.name

--4.Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. 
--Sort by grade, then by name within each grade. 
select name, grade
from highschooler
where id not in (select id1 from likes as id union select id2 from likes as id)
order by grade, name

--5.For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), 
--return A and B's names and grades. 
select h1.name,h1.grade,h2.name,h2.grade
from Likes, highschooler h1,highschooler h2
where likes.id1=h1.id and likes.id2=h2.id and likes.id2 not in(select id1 from likes)

--6.Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. 
select distinct h1.name, h1.grade
from friend f, highschooler h1, highschooler h2
where f.id1=h1.id and f.id2=h2.id and f.id1 not in 
(select f.id1 from friend f, highschooler h1, highschooler h2 where f.id1=h1.id and f.id2=h2.id and h1.grade<>h2.grade)
order by h1.grade, h1.name

--7.For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). 
--For all such trios, return the name and grade of A, B, and C. 
select distinct H1.name,H1.grade,H2.name,H2.grade,H3.name,H3.grade
from highschooler H1, highschooler H2, highschooler H3, friend f1, friend f2, likes
where likes.id1=h1.id and likes.id2=h2.id and 
likes.id2 not in (select id1 from friend where id2=h1.id)
and f1.id1=h1.id and f1.id2=h3.id and f2.id1=h2.id and f2.id2=h3.id

--8.Find the difference between the number of students in the school and the number of different first names. 
select count(*)-count(distinct name)
from highschooler

--9.Find the name and grade of all students who are liked by more than one other student. 
select name, grade 
from highschooler
where id in (select id2 from likes group by id2 having count(id2)>1 )

