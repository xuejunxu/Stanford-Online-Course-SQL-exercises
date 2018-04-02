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

