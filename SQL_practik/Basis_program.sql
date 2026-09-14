--Пропрацювання базових програм в PostgreSQL
select*
from users_sql_project;

select*
from users_sql_project
where user_age>50;

select user_name,user_age,user_city
from users_sql_project
order by user_age asc;

select *
from users_sql_project
order by user_city, user_age desc;

select user_name,user_city,user_age
from users_sql_project
order by user_city,loyalty_status desc;

select user_id,user_city,user_age
from users_sql_project
order by 2,3 desc,1;

select *
from users_sql_project
limit 10;

select user_name as name
,user_city as city
,user_age as age
from users_sql_project;

select
user_name as name
,user_city as city
,user_age as age
,user_gender
from users_sql_project
order by 3 desc
limit 5;

select
user_name as name
,user_city as city
,user_age as age
,user_gender as gender
from users_sql_project
where user_gender='Жінка'
order by 3 desc
limit 5;

select *
from users_sql_project
where user_gender ='Чоловік' and user_age>30;

select*
from users_sql_project
where user_city ='Дніпро' or user_gender='Чоловік';

select user_name, user_city,user_age
from users_sql_project
where user_name = 'Кравчук Андрій Петрович'or user_city='Вінниця'

select user_name,user_city,user_age
from users_sql_project
where user_age between 40 and 50;

select *
from users_sql_project
where user_email like 'bo%'

select *
from users_sql_project
where user_email like 'a%';

select *
from users_sql_project
where user_age between 25 and 50;

select *
from users_sql_project
where user_city in ('Харків');



