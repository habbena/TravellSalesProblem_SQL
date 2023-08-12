-- TASK 01

/*
Traveling Salesman Problem Path Finder in SQL
Задача коммивояжера с возвратом:
Дано 4 города и цены проезда между ними.
Найти все возможные маршруты с учетом возвращения в первый город. 
Первый город задан константной - город 'a'.
Отсортировать по убыванию.
*/

WITH RECURSIVE total_price (tour, first_city_id, last_city_id, total_cost, places_count) AS (
  SELECT
    CAST(name AS text),
    1,
    id,
    0,
    1
  FROM cities c
  WHERE c.name = 'a'
  UNION ALL
  SELECT
    t.tour || ', ' || c.name,
    1,
    c.id,
    t.total_cost + p.price,
    t.places_count + 1
  FROM total_price t
  JOIN price p
    ON t.last_city_id = p.city_from
  JOIN cities c
    ON c.id = p.city_to
  WHERE position(c.name IN t.tour) = 0
)
SELECT total_cost + t1.price AS total_cost, 
		'{' || tour || ', a}' AS tour
FROM total_price t
JOIN (
	SELECT * 
	FROM price
	WHERE city_from = 1) t1 
    ON t.last_city_id = t1.city_to
WHERE places_count = 4 
ORDER BY 1, 2 ;













