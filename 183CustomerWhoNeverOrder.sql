#Customer who never order
select name
from customers
where customers.id not in 
(select customerid
from orders)