/*
Traveling Salesman Problem Path Finder in SQL
Задача коммивояжера без возврата в первую точку:
Дано 4 города и цены проезда между ними.
Найти маршрут с минимальной ценой за проезд с посещением всех городов. 
Первый город задан, город 'a'.
*/

CREATE TABLE cities (
	id serial,
	name char(2)
);

INSERT INTO cities (name)
VALUES ('A'), ('B'), ('C'), ('D');

CREATE TABLE price(
	city_from int,
	city_to int,
	price int
);

INSERT INTO price (city_from, city_to, price)
VALUES 
(1, 2, 10),
(1, 3, 15),
(1, 4, 20),
(2, 1, 10),
(2, 3, 35),
(2, 4, 25),
(3, 1, 15),
(3, 2, 35),
(3, 4, 30),
(4, 1, 20),
(4, 2, 25),
(4, 3, 30)
;


WITH RECURSIVE total_price (tour, last_city_id, total_cost, places_count) AS (
  SELECT
    CAST(name AS text),
    id,
    0,
    1
  FROM cities c
  WHERE c.name = 'A'
  UNION ALL
  SELECT
    t.tour || ', ' || c.name,
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
SELECT total_cost, tour
FROM total_price
WHERE places_count = 4
ORDER BY 1, 2 ;









