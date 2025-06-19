SELECT * FROM pizza_runner.runners;
SELECT * FROM pizza_runner.customer_orders;
SELECT * FROM pizza_runner.runner_orders;
SELECT * FROM pizza_runner.pizza_names;
SELECT * FROM pizza_runner.pizza_recipes;
SELECT * FROM pizza_runner.pizza_toppings;

--Runner and Customer Experience

--1.How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
WITH week_cte AS 
	(SELECT runner_id, registration_date,
	registration_date - ((registration_date - '2021-01-01')%7) AS week_start
	FROM pizza_runner.runners
	)
SELECT COUNT(runner_id), 
week_start
FROM week_cte
GROUP BY week_start
ORDER BY week_start;

--2.What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
WITH avg_time AS(
	SELECT r.order_id, r.runner_id, 
	date_part('minute', r.pickup_time) as pickup_min,
	date_part('minute', c.order_time) as order_min,
	r.pickup_time - c.order_time AS time_diff
	FROM pizza_runner.runner_orders r
	JOIN pizza_runner.customer_orders c
	ON r.order_id = c.order_id
	WHERE distance != '' AND duration != ''
	)
SELECT runner_id, ROUND(AVG(date_part('minute', time_diff))::numeric, 0)
FROM avg_time
GROUP BY runner_id
ORDER BY runner_id;

--3.Is there any relationship between the number of pizzas and how long the order takes to prepare?
WITH pizza_prep_time AS(
	SELECT r.order_id, COUNT(c.pizza_id) AS pizza_count,
	date_part('minute', r.pickup_time) as pickup_min,
	date_part('minute', c.order_time) as order_min,
	r.pickup_time - c.order_time AS time_diff
	FROM pizza_runner.runner_orders r
	JOIN pizza_runner.customer_orders c
	ON r.order_id = c.order_id
	WHERE distance is not null AND duration != ''
	GROUP BY r.order_id, pickup_min, order_min, time_diff
	)
SELECT pizza_count, date_part('minutes', AVG(time_diff)) AS avg_prep_time
FROM pizza_prep_time 
GROUP BY pizza_count
ORDER BY pizza_count


--4.What was the average distance travelled for each customer?
--cleaning up the distance column
UPDATE pizza_runner.runner_orders
SET distance = NULL
WHERE distance = '';

UPDATE pizza_runner.runner_orders
SET distance = TRIM('km' FROM distance)
WHERE distance IS NOT NULL

ALTER TABLE pizza_runner.runner_orders
ALTER column distance TYPE numeric 
USING distance::numeric

--query for 4
SELECT c.customer_id,
ROUND(AVG(distance),2) AS avg_distance_travelled
FROM pizza_runner.customer_orders c
JOIN pizza_runner.runner_orders r
ON c.order_id = r.order_id
GROUP BY c.customer_id
ORDER BY c.customer_id


