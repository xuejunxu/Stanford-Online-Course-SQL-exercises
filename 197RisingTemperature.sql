#Approach: Using JOIN and DATEDIFF() clause [Accepted]
#Algorithm

#MySQL uses DATEDIFF to compare two date type values.

#So, we can get the result by joining this table weather with itself and use this DATEDIFF() function.

#MySQL

/* Write your T-SQL query statement below */
select w2.Id
from Weather w1,Weather w2
where datediff(day,w1.RecordDate,w2.RecordDate)=1 and w1.temperature<w2.temperature


/* Write your T-SQL query statement below */
select w2.Id
from Weather w1, Weather w2
where w1.Id+1=w2.Id and w1.Temperature<w2.Temperature
#this is not working because some test cases are tricky