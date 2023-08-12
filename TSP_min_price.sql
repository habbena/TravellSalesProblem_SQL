-- TASK 00
/*
Traveling Salesman Problem Path Finder in SQL
Задача коммивояжера с возвратом:
Дано 4 города и цены проезда между ними.
Найти маршрут с минимальной ценой за проезд с посещением всех городов с учетом возвращения в первый город. 
Первый город задан, город 'a'.
*/

-- таблица с названиями городов
CREATE TABLE cities (
	id serial,
	name char(2)
);

INSERT INTO cities (name)
VALUES ('a'), ('b'), ('c'), ('d');

-- таблица со стоимостью проезда между разными городами
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

/*
Создаем 3 CTE, одна из которых  с рекурсией.
total_price - 
здесь мы считаем стоимость проезда между всеми точками без учета возврата в первый город. 
Начинаем с машрута из двух городов, проходимся по всем вариантам.
tour -  текст маршрута вида (город_a, город_b и т.д.)
first_city_id - сначала задается город 'a'б потом меняется 
places_count - количество городов в маршруте

fin - здесь к сумме оплаты за 4 города добавлена цена за возврат домой
выбираем только те записи, где places_count = 4, то есть те маршруты, в которые включены все нужные города

short - из таблицы fin выбираем самую низкую стоимость итогового маршрута с учетом возврата

и в итоговой таблице я из таблицы fin оставляю только те записи, где цена маршрута = цене маршрута из таблицы short
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
),
fin AS (
        SELECT 
          total_cost + t1.price AS total_cost, 
          '{' || tour || ', a}' AS tour
        FROM total_price t
        JOIN (
            SELECT * 
            FROM price
            WHERE city_from = 1) t1 
          ON t.last_city_id = t1.city_to
        WHERE places_count = 4
        ORDER BY 1, 2),
short AS (
        SELECT 
          min(total_cost) AS short
        FROM fin
)
SELECT 
  total_cost, 
  tour
FROM fin 
RIGHT JOIN short 
  ON short.short = fin.total_cost

