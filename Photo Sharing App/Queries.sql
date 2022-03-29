select * from users;
select * from photos;
select * from comments;

-- Join Examples
select contents, username from comments
join users on users.id = comments.user_id;

select contents, url from comments
join photos on photos.id = comments.photo_id;

select url, username from photos
join users on users.id = photos.user_id;

insert into photos(url,user_id)
values('http://banner.jpg', null);

-- Left Join
-- select url, username from photos
-- left join users on users.id = photos.user_id;

-- insert into users(username)
-- values ('Maria');
--
-- Right Join
-- select url, username from users
-- right join photos on user_id = photos.user_id;
--
-- Full Join
-- select url, username from users
-- full join photos on user_id = photos.user_id;

select url, contents from comments
join photos on photos.id = comments.photo_id
where comments.user_id = photo_id;

-- Three way Join(Users that commented on their own photos)
select url, contents, username from comments
join photos on photos.id = comments.photo_id
join users on users.id  = comments.user_id and users.id = photos.user_id;

-- Using Group By(used to group rows by a unique set of values)
-- select user_id from comments
-- group by user_id;

-- Aggregate functions
select max(id) from comments;

select user_id, count(id) from comments
group by user_id;

-- null values are not counted
select count(user_id) from photos;

-- count everything
select count(*) from photos;

-- All users' comments
select user_id, count(*) from comments
group by user_id;

-- All users' photos with comments assigned
select photo_id, count(*) from comments
group by photo_id;

-- Using Having(used for filtering when we have aggregate functions)
select photo_id, count(*) from comments
where photo_id < 3
group by photo_id
having count(*) > 2;

select user_id, count(*) from comments
where photo_id <= 50
group by user_id
having count(*) > 20;