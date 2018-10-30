#sqlzoo

## Between clause
SELECT name, area FROM world
  WHERE area BETWEEN 200000 AND 250000

## LIKE clause
      SELECT name, population
      FROM world
      WHERE name LIKE 'Al%'
# 'xxx%' means begins with 'xxx'
# '%xxx' means ends with 'xxx'

#select anything where name contains United
select name
from world
where name LIKE '%United%'

#Exclusive OR (XOR). Show the countries that are big by area or big by population but not both. 
#Show name, population and area.

select name, population, area
from world
where (area>3000000 or population >250000000) and name not in
(select name from world
where area>3000000 and population >250000000)

#ROUND(f,p) returns f rounded to p decimal places.
SELECT name,
       ROUND(population/1000000,1)
  FROM bbc

#Matching name and capital
-- The capital of Sweden is Stockholm. Both words start with the letter 'S'.

-- Show the name and the capital where the first letters of each match. 
#Don't include countries where the name and the capital are the same word.
-- You can use the function LEFT to isolate the first character.
-- You can use <> as the NOT EQUALS operator.
SELECT name,
       LEFT(name, 3)
  FROM bbc

select name, capital
from world
where left(name,1)=left(capital,1) and name<>capital

-- The expression subject IN ('Chemistry','Physics') can be used as a value - it will be 0 or 1.

-- Show the 1984 winners and subject ordered by subject and winner name; but list 
--Chemistry and Physics last.

SELECT winner, subject
  FROM nobel
 WHERE yr=1984
 ORDER BY subject IN ('Physics','Chemistry'),subject,winner

--  Germany (population 80 million) has the largest population of the countries in Europe. 
-- Austria (population 8.5 million) has 11% of the population of Germany.
-- Show the name and the population of each country in Europe. 
--Show the population as a percentage of the population of Germany.

-- Decimal places
-- You can use the function ROUND to remove the decimal places.
-- Percent symbol % (*100 to get percentage)
-- You can use the function CONCAT to add the percentage symbol. CONCAT could concatenate two strings

select name, concat(round(population*100/(select population from world where name='Germany')),'%')
from world 
where continent ='Europe'

#Which countries have a GDP greater than every country in Europe? 
#[Give the name only.] (Some countries may have NULL gdp values)

select name from world
where GDP>(select GDP from world where continent = 'Europe' order by GDP desc limit 1 offset 0)

# another solultion to 
select name from world
where GDP>(select max(GDP) from world where continent = 'Europe')

# Find the largest country (by area) in each continent, show the continent, the name and the area:
SELECT continent, name, area
from world w1
where area>=ALL(Select w2.area from world w2 where w1.continent=w2.continent)

# List each continent and the name of the country that comes first alphabetically.
select continent,name
from world w1
where name <= All(select name from world w2
where w1.continent=w2.continent)

# Find the continents where all countries have a population <= 25000000. 
# Then find the names of the countries associated with these continents. 
# Show name, continent and population.
select name, continent, population
from world w1
where 25000000>=ALL(select population from world w2
where w1.continent=w2.continent)

# Some countries have populations more than three times that of any of their neighbours 
# (in the same continent). Give the countries and continents.
select name, continent
from world w1
where population >= all (select 3*population from world w2
where w1.continent=w2.continent and w1.name<>w2.name)

# List the continents that have a total population of at least 100 million.
select continent
from world
group by continent
having sum(population)>=100000000

# For each subject show the first year that the prize was awarded.
select subject, min(yr)
from nobel
group by subject

# Show the years in which three prizes were given for Physics.
select distinct yr
from nobel
where subject='Physics'
group by yr
having count(*)=3


# Show winners who have won more than one subject.
select winner
from nobel
group by winner
having count(distinct subject)>1

# Show the year and subject where 3 prizes were given. Show only years 2000 onwards.
select yr,subject
from nobel
where yr>=2000
group by yr, subject
having count(*)=3

