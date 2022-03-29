create table products (
  id serial primary key,
  name varchar(40),
  department varchar(40),
  price integer,
  weight integer
);

insert into products(name, department,price,weight)
values ('Shirt', 'Clothes', 20, 1);

select * from products;

insert into products(name, department,weight)
values ('Pants', 'Clothes', 3);

update products set price = 9999
where price is null;

alter table products
alter column price
set not null;

alter table products
add unique(name,department);

alter table products
add check(price > 0);

insert into products(name,department,price,weight)
values('Belt', 'Clothes',-99,1);

create table orders (
    id serial primary key,
    name varchar(40) not null,
    created_at timestamp not null,
    est_delivery timestamp not null,
    check(created_at < est_delivery)
);


insert into orders(name,created_at,est_delivery)
values('Shirt','2000-NOV-20 01:00AM', '2000-NOV-25 01:00AM');
