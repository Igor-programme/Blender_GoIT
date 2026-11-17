
--Закази по місяцях
select date_trunc('month',order_date)::date as order_month,
count(distinct order_id) as total_orders
from orders_sql_project
group by 1;

--Середня кількість заказів в місяць
select avg(total_orders) as avg_orders_per_month
from(select date_trunc('month',order_date)::date as order_month,
count(distinct order_id) as total_orders
from orders_sql_project
group by 1) as month_orders;

--Користувачі із Житомира
select *
from project.users_sql_project
where user_city='Житомир';

select *
from project.orders_sql_project;

--Кількість замовлень по користувачах із Житомира
select user_id,count(distinct order_id) as total_orders
from project.orders_sql_project
where user_id in (select user_id
from project.users_sql_project
where user_city='Житомир')
group by user_id
order by total_orders desc;

--Середня ціна за продукт
select product_id,product_name,product_category,product_price,
round((select avg(product_price) from project.products_sql_project),2) as avg_product
from project.products_sql_project;

--Середня ціна продукту за категоріями
select product_id,product_name,product_category,product_price,
round(
(select avg(product_price) from project.products_sql_project psp
where psp.product_category=p.product_category),2)
as avg_price_per_category
from project.products_sql_project p
order by product_category;

--Винесення заказів з максимальною і мінімальною кількістю замовлень із сортуванням за спадінням
select order_id, sum(quantity) as quantity_per_order
from project.order_items_sql_project
group by order_id
having sum(quantity) =6 or sum(quantity)=1
order by 2 desc;

select*
from project.order_items_sql_project;

--Загальна середня кількість по замовленням
select round(avg(quantity_per_order),2) as avg_per_order
from (select order_id, round(sum(quantity),2) as quantity_per_order
from project.order_items_sql_project
group by order_id
having round(sum(quantity),2) =6 or round(sum(quantity),2)=1
order by 2 desc) as orders_quantity;

--Загальна кількість замовлень по заказах сортування за спадінням
select order_id, sum(quantity) as quantity_per_order
from project.order_items_sql_project
group by order_id
order by 2 desc;

-- мінімалана і максимальна кількість замовлень
select min(quantity_per_order),max(quantity_per_order)
from(select order_id, sum(quantity) as quantity_per_order
from project.order_items_sql_project
group by order_id
order by 2 desc) as quantity_per_order;

--Кількість замовлень що припадають на місяці
with month_per_orders as (select date_trunc('month',order_date)::date as order_month,
count(distinct order_id) as total_orders
from orders_sql_project
group by 1)
select *
from month_per_orders;

--Приклад використання СТЕ замовлення з максимальною і мінімальною кількостью продукції
with quan_per_order as (
select order_id,
sum(quantity) as quantity_per_order
from project.order_items_sql_project
group by order_id
order by 2 desc)
select*
from quan_per_order
where quantity_per_order =(select max(quantity_per_order) from quan_per_order)
or quantity_per_order = (select min(quantity_per_order) from quan_per_order);

--Використання каскадного СТЕ, середня ціна по категоріям вище 20000 без пропущених значень
with cat_avg_price as (
select
product_category,
round(avg(product_price),2) as avg_category_price
from project.products_sql_project
group by product_category
having avg(product_price) >20000),
prices_with_avg as (
select product_id,product_name,product_category,product_price,
(select avg_category_price
from cat_avg_price
where cat_avg_price.product_category=products_sql_project.product_category)
from products_sql_project)
select*
from prices_with_avg
where avg_category_price is not null and product_price>avg_category_price;


