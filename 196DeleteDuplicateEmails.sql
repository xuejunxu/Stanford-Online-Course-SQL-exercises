#delete all duplicate emails
#can do something based on different ids

#Leetcode accepted
delete from person
	where id in 
	(select pid from (select p1.id as pid
		from person p1, person p2
		where p1.id>p2.id and p1.email=p2.email) as p)

#Not passed
delete from person
	where id in 
	(select p1.id
		from person p1, person p2
		where p1.id>p2.id and p1.email=p2.email) 

#can't specify target table 'person' for update in FROM clause delete
#you can't delete from the same table person from your FROM clause. Should put one more select and then name it as a new table