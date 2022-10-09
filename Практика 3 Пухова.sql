--=============== МОДУЛЬ 3. ОСНОВЫ SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите для каждого покупателя его адрес проживания, 
--город и страну проживания.

select concat(first_name,' ', last_name) as "Фамилия и имя", a.address as "Адрес", c2.city as "Город", c3.country as "Страна"
from customer c 
join address a  on a.address_id = c.address_id
join city c2 on c2.city_id = a.city_id 
join country c3 on c3.country_id = c2.country_id;



--ЗАДАНИЕ №2
--С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.

select s.store_id, count(c.last_name)
from store s 
join customer c on c.store_id = s.store_id 
group by s.store_id; 



--Доработайте запрос и выведите только те магазины, 
--у которых количество покупателей больше 300-от.
--Для решения используйте фильтрацию по сгруппированным строкам 
--с использованием функции агрегации.

select s.store_id, count(c.customer_id) 
from store s 
join customer c on c.store_id = s.store_id 
group by s.store_id
having count(c.customer_id) > 300;



-- Доработайте запрос, добавив в него информацию о городе магазина, 
--а также фамилию и имя продавца, который работает в этом магазине.

select s.store_id as "ID магазина", count(c.customer_id) as "Количество покупателей", city as "Город", concat(s2.first_name, ' ', s2.last_name) as "Имя сотрудника" 
from store s 
join customer c on c.store_id = s.store_id 
join address a on a.address_id = s.address_id
join city c2 on c2.city_id = a.city_id 
join staff s2 on s2.staff_id = s.manager_staff_id 
group by s.store_id, city, concat(s2.first_name, ' ', s2.last_name)
having count(c.customer_id) > 300;



--ЗАДАНИЕ №3
--Выведите ТОП-5 покупателей, 
--которые взяли в аренду за всё время наибольшее количество фильмов

select concat(last_name,' ', first_name) as "Фамилия и имя", count(i.film_id)   
from customer c 
join rental r on r.customer_id = c.customer_id 
join inventory i on i.inventory_id = r.inventory_id 
group by concat(last_name,' ', first_name)
order by count(i.film_id) desc limit 5;



--ЗАДАНИЕ №4
--Посчитайте для каждого покупателя 4 аналитических показателя:
--  1. количество фильмов, которые он взял в аренду
--  2. общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа)
--  3. минимальное значение платежа за аренду фильма
--  4. максимальное значение платежа за аренду фильма

select concat(last_name,' ', first_name) as "Фамилия и имя", count(i.film_id) as "Количество фильмов", 
round(sum(p.amount)) as "Сумма платежей", min(p.amount) as "Минимальный платеж", max(p.amount) as "Максимальный платеж" 
from customer c 
join rental r on r.customer_id = c.customer_id 
join inventory i on i.inventory_id = r.inventory_id 
join payment p on p.rental_id = r.rental_id 
group by concat(last_name,' ', first_name)



--ЗАДАНИЕ №5
--Используя данные из таблицы городов составьте одним запросом всевозможные пары городов таким образом,
 --чтобы в результате не было пар с одинаковыми названиями городов. 
 --Для решения необходимо использовать декартово произведение.
 
select c.city city_one, c2.city city_two
from city c, city c2 
where c.city != c2.city;



--ЗАДАНИЕ №6
--Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date)
--и дате возврата фильма (поле return_date), 
--вычислите для каждого покупателя среднее количество дней, за которые покупатель возвращает фильмы.
 
select c.customer_id as "ID покупателя", round(avg((return_date::date)-(rental_date::date)),2) as "Среднее количество дней" 
from rental r 
join customer c on c.customer_id = r.customer_id 
group by c.customer_id;

