— First queries
-- Create the first table
create table cities(
  name varchar(50),
  country varchar(50),
  population integer,
  area integer
);
 -- Insert row
insert into cities (name,country,population,area)
values ('Tokyo','Japan',38505000, 8223);

-- Insert multiple rows
insert into cities(name,country,population,area)
values
('Delhi','India',28125000,2240),
('Shanghai','China',22125000,4015),
('Sao Paulo','Brazil',20935000,3043);

-- Retrieve data
select * from cities;

-- Calculated columns(density)
select name, population / area as population_density
from cities;

-- String operators and functions
select name || ', ' || country as location
from cities;

select concat(name,', ',country) as location from cities;

select upper(concat(name,', ',country)) as location from cities;

-- Filtering with WHERE
select name, area from cities
where area > 4000;

select name, area from cities
where area between 2000 and 4000;

select name, area from cities
where name in ('Delhi','Tokyo');

select name, area from cities
where name not in ('Delhi','Tokyo');

select name, population / area as population_density
from cities
where population / area > 6000;

-- Update table
update cities set population = 39505000
where name = 'Tokyo';

select name, population from cities where name = 'Tokyo';

-- Delete rows
delete from cities where name = 'Tokyo';

select * from cities;