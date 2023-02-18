-- three nodes network
drop table if exists citiesset1, citiesset2, citiesset3, connections; 
create table citiesset1 (ID int primary key, cityname varchar(50)) as node;
create table citiesset2 (ID int primary key, cityname varchar(50)) as node;
create table citiesset3 (ID int primary key, cityname varchar(50)) as node;
create table connections (distance int) as edge;  -- create table connections as edge; 

insert into citiesset1 (ID, cityname) values (1,'Paris') , (2,'Geneva'), (3,'Milan');
insert into citiesset2 (ID, cityname) values (1,'Berlin') , (2,'Prague'), (3,'Munich');
insert into citiesset3 (ID, cityname) values (1,'Budapest') , (2,'Vienna'), (3,'Warsaw');

insert into connections values -- driving distances between cities
(( select $node_id from citiesset1 where ID = 1), (select $node_id from citiesset2 where ID = 2), 1035),
(( select $node_id from citiesset1 where ID = 1), (select $node_id from citiesset2 where ID = 3), 841),
(( select $node_id from citiesset2 where ID = 2), (select $node_id from citiesset3 where ID = 3), 676),
(( select $node_id from citiesset2 where ID = 1), (select $node_id from citiesset3 where ID = 3), 573), 
(( select $node_id from citiesset2 where ID = 3), (select $node_id from citiesset3 where ID = 2), 434),
(( select $node_id from citiesset2 where ID = 3), (select $node_id from citiesset3 where ID = 3), 1071),
(( select $node_id from citiesset1 where ID = 2), (select $node_id from citiesset2 where ID = 1), 1110); 

-- show all routes linking Paris to Warsaw
select c1.cityname as 'links from', c2.cityname as 'through', c3.cityname as 'linking to'
from citiesset1 as c1, connections as con1, connections as con2, citiesset2 as c2, citiesset3 as c3 where 
match (c1-(con1)->c2 and c2-(con2)->c3)  and c1.cityname = 'Paris' and c3.cityname = 'Warsaw';
 
-- show all routes leading to Warsaw
(select c1.cityname as 'links from', c2.cityname as 'through', c3.cityname as 'linking to', (con1.distance + con2.distance) as distance
from citiesset1 as c1, connections as con1, connections as con2, citiesset2 as c2, citiesset3 as c3 where 
match (c1-(con1)->c2 and c2-(con2)->c3)  and  c3.cityname = 'Warsaw')  

-- find the shortest one
select top(1) * from
(select c1.cityname as 'links from', c2.cityname as 'through', c3.cityname as 'linking to', (con1.distance + con2.distance) as distance
from citiesset1 as c1, connections as con1, connections as con2, citiesset2 as c2, citiesset3 as c3 where 
 match (c1-(con1)->c2 and c2-(con2)->c3)  and  c3.cityname = 'Warsaw') as y order by distance asc;
