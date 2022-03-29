-- Where data is stored on local memory:
-- show data_directory;
-- select oid, datname from pg_database;
-- select * from pg_class;

-- Creating and deleting an index
create index on users(username);
drop index users_username_idx;

-- Benchmarking queries
-- Execution time: with index 0.096ms, without index 1.275ms
explain analyze select * from users 
where username = 'Emil30';

-- Common table expresions
-- Normal query:
select username,tags.created_at
from users
join (select user_id,created_at from caption_tags
	 union
	 select user_id,created_at from photo_tags) as tags on tags.user_id = users.id
where tags.created_at < '2010-01-07';
-- Rewritten query with CTE(easier to read):
with tags as(select user_id,created_at from caption_tags
	 union
	 select user_id,created_at from photo_tags)
select username,tags.created_at
from users
join tags on tags.user_id = users.id
where tags.created_at < '2010-01-07';

-- Recursive CTEs(ALL of them have the UNION keyword, used to fetch data from
-- a tree or graph structure(any type of hierarchy)):
with recursive countdown(val) as (
	select 3 as val -- initial, non-recursive query
	union
	select val - 1 from countdown where val > 1 --recursive query
)
select * from countdown;

-- Follower suggestion for a specific user using recursive CTE
with recursive suggestions(leader_id,follower_id,depth) as
(
	select leader_id,follower_id,1 as depth from followers
	where follower_id = 1000
union
	select followers.leader_id,followers.follower_id,depth+1
	from followers
	join suggestions on suggestions.leader_id = followers.follower_id
	where depth < 3
)
select distinct users.id,users.username from suggestions
join users on users.id = suggestions.leader_id
where depth > 1
limit 30;

-- Views(a fake table with rows from other tables)
-- most popular users(who were tagged the most):
select username,count(*)
from users
join (select user_id from photo_tags
	 union all
	 select user_id from caption_tags) as tags on tags.user_id = users.id
group by username
order by count(*) desc;
-- Creating a view for the union between photo_tags and caption_tags tables
create view tags as 
(
	select id,created_at,user_id,post_id,'photo_tag' as type from photo_tags
	union all
	select id,created_at,user_id,post_id, 'caption_tag' as type from caption_tags
);

select * from tags;
-- most popular users with views:
select username,count(*) from users
join tags on tags.user_id = users.id
group by username
order by count(*) desc;

-- 10 most recent posts example:
create view recent_posts as
(
	select * from posts
	order by created_at desc
	limit 10
);

select * from recent_posts;

select username from recent_posts
join users on users.id = recent_posts.user_id;

-- Deleting and changing views
create or replace view recent_postst as
(
	select * from posts
	order by created_at desc
	limit 15
);

select * from recent_posts;
drop view recent_posts;

-- Materialized Views
-- (query that gets executed only at very specific times, but the results
-- are saved and can be referenced without rerunning the query)
-- Normal query example: for each week, show the number of likes that posts and
-- comments received. Use the post and comment created_at date, not when the like
-- was received
select date_trunc('week',coalesce(posts.created_at,comments.created_at)) as week,
count(posts.id) as num_likes_for_posts,
count(comments.id) as num_likes_for_comments
from likes
left join posts on posts.id = likes.post_id
left join comments on comments.id = likes.comment_id
group by week
order by week;

-- Creating a materialized view
create materialized view weekly_likes as
(
	select date_trunc('week',coalesce(posts.created_at,comments.created_at)) as week,
	count(posts.id) as num_likes_for_posts,
	count(comments.id) as num_likes_for_comments
	from likes
	left join posts on posts.id = likes.post_id
	left join comments on comments.id = likes.comment_id
	group by week
	order by week
) with data;
select * from weekly_likes;

-- Refreshing materialized views
refresh materialized view weekly_likes;

create table accounts(
	id serial primary key,
	name varchar(20) not null,
	balance integer not null);	
insert into accounts(name, balance)
values  ('Gia', 100),
		('Alyson',100);		
		
select * from accounts;

-- Transactions
-- Creating a transaction
begin;
update accounts
set balance = balance - 50
where name = 'Alyson';

update accounts
set balance = balance + 50
where name = 'Gia';

-- Commit changes
commit;

-- Abort transaction
rollback;