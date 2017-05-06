drop table if exists cities; 
drop table if exists connections; 
create table cities (ID integer primary key, cityname varchar(50)) as node;
create table connections as edge; 
insert into cities (ID, cityname) values (1,'London') , (2,'Paris'), (3,'Rome');

insert into connections values 
(( select $node_id from cities where ID = 1), (select $node_id from cities where ID = 2)),
(( select $node_id from cities where ID = 2), (select $node_id from cities where ID = 3)),
(( select $node_id from cities where ID = 1), (select $node_id from cities where ID = 3)),
(( select $node_id from cities where ID = 3), (select $node_id from cities where ID = 1));

select c1.cityname  as 'links to London'
from cities as c1, connections, cities as c2 where 
match (c1-(connections)->c2) and c2.cityname = 'London'

select c2.cityname  as 'links from London'
from cities as c1, connections, cities as c2 where 
match (c1-(connections)->c2) and c1.cityname = 'London'


