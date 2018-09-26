--duplicate emails

select distinct e1.email
from person e1, person e2
where e1.email=e2.email and e1.id<>e2.id