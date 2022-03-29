select * from users;
select * from products;
select * from orders;

-- Sorting
select * from products
order by price; -- DESC

select * from products
order by price, weight; -- DESC(asc price, desc weight)

-- Offset(everytime we want to skip a number of records) and Limit(constrains the number of records of the result set)

select count(*) from users;
select * from users offset 40; -- only shows the last 10 users

select * from users limit 5;

select * from products
order by price
limit 5;

select * from products
order by price
limit 5
offset 2;

-- Union(Union All leaves duplicates - join together the results of two queries)
(select * from products
order by price desc
limit 4)
union
(select * from products
order by price / weight desc
limit 4);

-- Intersect/Intersect All(find the rows common in the result of two queries)
(select * from products
 order by price desc
 limit 4)
intersect
(select * from products
 order by price / weight desc
 limit 4);

-- Except/Except All(find the rows that are present in the first query but not in the second)
(select * from products
 order by price desc
 limit 4)
except
(select * from products
 order by price / weight desc
 limit 4);

-- Subqueries
select name, price from products
where price > (select max(price) from products where department = 'Toys');

-- Subquery that results in a single value:
select name, price, (select max(price) from products)
from products
where price > 867;

-- Subqueries in a FROM
select * from(select max(price) from products) as p;

select avg(order_count)
from (select user_id, count(*) as order_count from orders
group by user_id) as p;

-- Subqueries with WHERE
select id from orders
where product_id in ( select id from products where price / weight > 50);

select name from products
where price > (select avg(price) from products);

-- NOT IN operator
select name, department from products
where department not in (select department from products where price < 100);

-- Operators in WHERE clause(All, Some(same as ANY))
select name, department, price from products
where price > all (select price from products where department = 'Industrial');

select name, department, price from products
where price > some(select price from products where department = 'Industrial');

-- Correlated subqueries
-- Show the name, department and price of the most expensive product in each department
select name, department, price from products as p1
where p1.price = (select max(price) from products as p2 where p2.department = p1.department);

-- Without using group by or join, print the number of orders for each product
select name, (select count(*) from orders as o1 where o1.product_id = p1.id) as num_orders
from products as p1;

-- Select without From(a subquery in select as long as the query returns a single value)
select(select max(price) from products), (select avg(price) from products);

-- Distinct(unique values)
select distinct department from products;

select count(distinct department) from products;

-- Gratest/Least value, Case keyword
select name, weight, greatest(30, 2 * weight) from products;

select name, price, least(400, price * 0.5) from products;

select
    name,
    price,
    case
        when price > 600 then 'high'
        when price > 300 then 'medium'
        else 'cheap'
    end
from products;