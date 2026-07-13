SET search_path TO public;


-- БАЗОВАЯ ВЫБОРКА И ФИЛЬТРАЦИЯ ДАННЫХ


-- 1. Получение уникальных названий городов
SELECT DISTINCT city
FROM city;


-- 2. Фильтрация городов по паттерну (начинаются на "L", заканчиваются на "a", без пробелов)
SELECT DISTINCT city
FROM city
WHERE city LIKE 'L%a' 
  AND city NOT LIKE '% %';


-- 3. Топ-10 последних платежей за прокат фильмов
SELECT *
FROM payment
ORDER BY payment_id DESC
LIMIT 10;


-- 4. Форматирование контактных данных клиентов и расчет длины email
SELECT 
    CONCAT_WS(' ', last_name, first_name) AS customer_full_name,
    email, 
    SUBSTRING(email FROM POSITION('@' IN email)) AS email_domain,
    LENGTH(email) AS email_length
FROM customer;


-- 5. Список активных клиентов с именами KELLY или WILLIE (приведение к нижнему регистру)
SELECT 
    LOWER(last_name) AS last_name_lower,
    LOWER(first_name) AS first_name_lower,
    activebool AS is_active
FROM customer
WHERE active = 1 
  AND (first_name = 'KELLY' OR first_name = 'WILLIE');


-- 6. Фильтрация фильмов по названию, длине описания и соотношению цены к длительности
SELECT 
    film_id,
    title,
    ROUND(rental_rate::numeric / length, 3) AS rental_rate_per_minute
FROM film
WHERE title ILIKE 'be%' 
  AND LENGTH(description) > 100 
  AND ROUND(rental_rate::numeric / length, 3) > 0.015;


-- ДОПОЛНИТЕЛЬНЫЕ ЗАПРОСЫ И РАБОТА СО СТРОКАМИ


-- 7. Фильтрация фильмов по рейтингу и диапазону стоимости аренды
SELECT 
    title,
    rating,
    rental_rate
FROM film 
WHERE (rating = 'R' AND rental_rate BETWEEN 0.00 AND 3.00) 
   OR (rating = 'PG-13' AND rental_rate >= 4.00);


-- 8. Топ-3 фильма с самым длинным описанием
SELECT 
    title,
    description,
    LENGTH(description) AS description_length
FROM film 
ORDER BY description_length DESC 
LIMIT 3;


-- 9. Разделение email адреса на имя ящика и домен
SELECT 
    email,
    SUBSTRING(email FROM 1 FOR POSITION('@' IN email) - 1) AS email_mailbox,
    SUBSTRING(email FROM POSITION('@' IN email) + 1) AS email_domain
FROM customer;


-- 10. Разделение email с форматированием строк (Первая буква заглавная)
SELECT 
    email,
    INITCAP(SUBSTRING(email FROM 1 FOR POSITION('@' IN email) - 1)) AS formatted_mailbox,
    INITCAP(SUBSTRING(email FROM POSITION('@' IN email) + 1)) AS formatted_domain
FROM customer;
