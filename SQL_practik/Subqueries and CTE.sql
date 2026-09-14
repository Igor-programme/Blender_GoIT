-- Товари, ціна яких перевищує середню ціну по всьому каталогу
select
product_id,
product_name,
product_price,
product_category
from project.products_sql_project
where product_price>(select round(avg(product_price),2) from products_sql_project)
order by product_category desc;


select
product_category,
round(avg(product_price),2) as avg_product_price
from products_sql_project
group by product_category;

select
round(avg(product_price),-3) as avg_product
from products_sql_project;

--Знайти користувача старшого віку
select
user_id,
user_name,
user_age,
user_city,
loyalty_status
from project.users_sql_project
where user_age=(select max(user_age) from users_sql_project)
order by user_name;


--Групуємо за order_id та підсумовуємо quantity для кожного замовлення,
select
order_id, sum(quantity) as total_quantity
from project.order_items_sql_project
group by order_id;

/*Замовлення де загальна кількість товару перевичує 5 одиниць,працює з проміжною таблицею order_totals як зі звичайною таблицею
  , PostgreSQL фільтрує рядки проміжної таблиці*/
SELECT
order_id,
total_quantity
FROM (
SELECT
order_id,
SUM(quantity) AS total_quantity
FROM project.order_items_sql_project
GROUP BY order_id
) AS order_totals
WHERE total_quantity > 5
ORDER BY total_quantity DESC
LIMIT 10;

--Завдання: наскільки ціна відрізняється від середньої ціни в каталозі для кожного товару
SELECT
product_id,
product_name,
product_price,
(SELECT ROUND(AVG(product_price),2) FROM products_sql_project) AS avg_price,
product_price - (SELECT ROUND(AVG(product_price),2) FROM products_sql_project) AS price_difference
FROM products_sql_project
ORDER BY price_difference DESC
LIMIT 10;

--Замовлення де загальна кількість товару перевищує 5 одиниц, СТЕ
WITH order_totals AS (
SELECT
order_id,
SUM(quantity) AS total_quantity
FROM project.order_items_sql_project
GROUP BY order_id
)
SELECT
order_id,
total_quantity
FROM order_totals
WHERE total_quantity >= 5
ORDER BY total_quantity DESC, order_id
LIMIT 10;

/*WITH order_totals AS PostgreSQL виконує запит всередині СТЕ,
групує за order_id  та підсумовує quantity */

SELECT order_id, SUM(quantity) AS total_quantity
FROM project.order_items_sql_project
GROUP BY order_id;

/*Завдання: треба знайти товари, ціна яких перевищує середню ціну по їхній категорії,
 але тільки для тих категорій, де середня ціна вища за 20000 грн. Бажано сторити каскадне СТЕ*/
WITH category_avg AS (
SELECT
product_category,
AVG(product_price) AS avg_category_price
FROM products_sql_project
GROUP BY product_category
HAVING AVG(product_price) > 20000
),
products_with_avg AS (
SELECT
product_id,
product_name,
product_category,
product_price,
(SELECT avg_category_price
FROM category_avg
WHERE product_category = p.product_category) AS avg_category_price
FROM products_sql_project p
)
SELECT
product_id,
product_name,
product_category,
product_price,
ROUND(avg_category_price, 2) AS avg_category_price
FROM products_with_avg
WHERE avg_category_price IS NOT NULL
AND product_price > avg_category_price
ORDER BY product_category, product_price DESC;


/*Покрокове виконання
 Крок 1. WITH category_avg AS (...)
PostgreSQL рахує середню ціну для кожної категорії товарів та одразу фільтрує категорії */

SELECT
product_category,
ROUND(AVG(product_price),2) AS avg_category_price
FROM products_sql_project
GROUP BY product_category
HAVING AVG(product_price) > 20000;

/*Крок 2. WITH products_with_avg AS (...)
PostgreSQL виконує другий CTE, який базується на першому.*/

WITH category_avg AS (
SELECT
product_category,
AVG(product_price) AS avg_category_price
FROM products_sql_project
GROUP BY product_category
HAVING AVG(product_price) > 20000
),
products_with_avg AS (
SELECT
product_id,
product_name,
product_category,
product_price,
(SELECT avg_category_price
FROM category_avg
WHERE product_category = p.product_category) AS avg_category_price
FROM products_sql_project p
)
SELECT *
FROM products_with_avg;

/*
Крок 3. WHERE — подвійна фільтрація
PostgreSQL застосовує дві умови:
1. WHERE avg_category_price IS NOT NULL
2. AND product_price > avg_category_price
Крок 4. SELECT з основного запиту звертається до другого СТЕ
PostgreSQL відбирає потрібні стовпці та округлює avg_category_price.
Крок 5. ORDER BY product_category, product_price DESC
PostgreSQL сортує спочатку за категорією, потім за ціною від більшої до меншої.*/

WITH category_avg AS (
SELECT
product_category,
AVG(product_price) AS avg_category_price
FROM products_sql_project
GROUP BY product_category
HAVING AVG(product_price) > 20000
),
products_with_avg AS (
SELECT
product_id,
product_name,
product_category,
product_price,
(SELECT avg_category_price
FROM category_avg
WHERE product_category = p.product_category) AS avg_category_price
FROM products_sql_project p
)
SELECT
product_id,
product_name,
product_category,
product_price,
ROUND(avg_category_price, 2) AS avg_category_price
FROM products_with_avg
WHERE avg_category_price IS NOT NULL
AND product_price > avg_category_price
ORDER BY product_category, product_price DESC;

/*CTE для знаходження користувачів старших за середній вік у своєму місті.
 Завдання: маркетолог хоче знайти міста, де є користувачі старші за середній вік по цьому місту (для таргетованої реклами)*/

WITH user_with_avg AS (
SELECT user_id,
user_name,
user_city,
user_age,
(SELECT AVG(user_age) FROM users_sql_project
WHERE user_city = u.user_city) AS city_avg_age
FROM users_sql_project u )
SELECT user_id,
user_name,
user_city,
user_age,
ROUND(city_avg_age, 1) AS city_avg_age
FROM user_with_avg
WHERE user_age > city_avg_age
ORDER BY user_age DESC;

/*Крок 1. WITH user_with_avg AS (...)
PostgreSQL виконує CTE
PostgreSQL отримує інформацію про користувачів: ідентифікатор, імʼя, місто, вік та в підзапиті рахує середній вік в межах міста.*/

SELECT user_id,
user_name,
user_city,
user_age,
(SELECT ROUND(AVG(user_age),2) FROM users_sql_project
WHERE user_city = u.user_city) AS city_avg_age
FROM users_sql_project u;

/* Крок 2. SELECT з ROUND
PostgreSQL вибирає дані з CTE та округлює середній вік до 1 знака після коми.
Крок 3. WHERE user_age > city_avg_age
PostgreSQL фільтрує користувачів, залишаючи тільки тих, чий вік більший за середній у їхньому місті.
Крок 4. ORDER BY user_age DESC
PostgreSQL сортує користувачів за віком від більшого до меншого.*/


WITH user_with_avg AS (
SELECT user_id,
user_name,
user_city,
user_age,
(SELECT AVG(user_age) FROM users_sql_project
WHERE user_city = u.user_city) AS city_avg_age
FROM users_sql_project u )
SELECT user_id,
user_name,
user_city,
user_age,
ROUND(city_avg_age, 1) AS city_avg_age
FROM user_with_avg
WHERE user_age > city_avg_age
ORDER BY user_age DESC;
