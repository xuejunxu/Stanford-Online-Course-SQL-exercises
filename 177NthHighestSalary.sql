CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
DECLARE M INT;
SET M=N-1;
  RETURN (
      # Write your MySQL query statement below.
      select distinct Salary
      from Employee
      order by Salary desc
      limit 1 offset M
  );
END

# create a function in SQL format as above
# introduce a new variable use DECLARE var TYPE;
# SET sth to something.

#limit offset combination, means take 1 and skipping the m variables ahead.