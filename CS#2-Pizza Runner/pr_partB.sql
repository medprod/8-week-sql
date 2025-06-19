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




	


