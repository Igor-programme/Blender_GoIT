select*
from employees;


select
first_name
,last_name
,salary
from employees
where salary>50000;

select
employee_id
,first_name
,last_name
from employees
where employee_id=10;

select *
from departments;

SELECT
    d.department_name
FROM employees e
inner JOIN departments d ON e.department_id = d.department_id;

SELECT
    d.department_name,
    COUNT(*) AS total_employees,
    AVG(salary) AS avg_salary
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id

WHERE d.department_name IS NOT NULL
GROUP BY d.department_name
ORDER BY avg_salary;

SELECT
    e.last_name,
    e.first_name,
    d.department_name,
    e.salary AS highest_salary
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
ORDER BY e.salary DESC
LIMIT 1;

select
d.department_name
,sum(salary) as total_salary
from employees e
inner join departments d on e.department_id=d.department_id
group by d.department_name
order by total_salary desc;

select
hire_date
,avg(salary) as avg_salary
from employees
where hire_date>='2022-01-01'
group by hire_date
order by hire_date asc;

select
d.department_name
,round(avg(salary),0) as avg_salary
from employees e
left join departments d on e.department_id=d.department_id
where d.department_name is not NULL
group by d.department_name
order by avg_salary desc;


select
d.department_name
,round(avg(salary),0) as avg_salary
from employees e
left join departments d on e.department_id=d.department_id
where d.department_name is not NULL
group by d.department_name
order by avg_salary desc
limit 1
offset 1;


select
last_name
,d.department_name
,round(sum(salary),2) as total_salary
from employees e
left join departments d on e.department_id=d.department_id
where d.department_name is not null and d.department_name='IT'
group by last_name,d.department_name
order by total_salary desc
limit 5;






