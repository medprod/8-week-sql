SELECT * FROM pizza_runner.runners;
SELECT * FROM pizza_runner.customer_orders;
SELECT * FROM pizza_runner.runner_orders;
SELECT * FROM pizza_runner.pizza_names;
SELECT * FROM pizza_runner.pizza_recipes;
SELECT * FROM pizza_runner.pizza_toppings;

--removing null values from runner_orders and customer_orders tables
UPDATE pizza_runner.runner_orders
SET 
  pickup_time = CASE WHEN pickup_time IS NULL OR pickup_time = 'null' THEN '' ELSE pickup_time END,
  distance = CASE WHEN distance IS NULL OR distance = 'null' THEN '' ELSE distance END,
  duration = CASE WHEN duration IS NULL OR duration = 'null' THEN '' ELSE duration END,
  cancellation = CASE WHEN cancellation IS NULL OR cancellation = 'null' THEN '' ELSE cancellation END
WHERE 
  pickup_time IS NULL OR pickup_time = 'null' OR
  distance IS NULL OR distance = 'null' OR
  duration IS NULL OR duration = 'null' OR
  cancellation IS NULL OR cancellation = 'null';

UPDATE pizza_runner.customer_orders
SET 
  exclusions = CASE WHEN exclusions IS NULL OR exclusions = 'null' THEN '' ELSE exclusions END,
  extras = CASE WHEN extras IS NULL OR extras = 'null' THEN '' ELSE extras END
WHERE 
  extras IS NULL OR extras = 'null' OR
  exclusions IS NULL OR exclusions = 'null';


--changing the data type of pickup_time from varchar to timestamp
ALTER TABLE pizza_runner.runner_orders
ALTER COLUMN pickup_time TYPE TIMESTAMP
USING to_timestamp(pickup_time, 'YYYY-MM-DD HH24:MI:SS')


--1. How many pizzas were ordered?
SELECT COUNT(order_id) AS total_pizzas_ordered
FROM pizza_runner.customer_orders;

--2.How many unique customer orders were made?
SELECT COUNT(DISTINCT customer_id) AS distinct_customers
FROM pizza_runner.customer_orders;

--3.How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(DISTINCT order_id) AS successful_deliveries
FROM pizza_runner.runner_orders
WHERE cancellation = ''
GROUP BY runner_id;

--4.How many of each type of pizza was delivered?
SELECT c.pizza_id, COUNT(c.order_id) AS delivered_pizzas
FROM pizza_runner.customer_orders c 
JOIN pizza_runner.runner_orders r
ON c.order_id = r.order_id
WHERE cancellation = ''
GROUP BY c.pizza_id;

--5.How many Vegetarian and Meatlovers were ordered by each customer?
SELECT c.customer_id, p.pizza_name, COUNT(c.order_id)
FROM pizza_runner.customer_orders c
JOIN pizza_runner.pizza_names p
ON c.pizza_id = p.pizza_id
GROUP BY c.customer_id, p.pizza_name
ORDER BY c.customer_id

--6.What was the maximum number of pizzas delivered in a single order?
SELECT c.order_id, COUNT(c.pizza_id) AS number_of_pizzas
FROM pizza_runner.customer_orders c
JOIN pizza_runner.runner_orders r
ON c.order_id = r.order_id
WHERE r.cancellation = ''
GROUP BY c.order_id
ORDER BY number_of_pizzas DESC
LIMIT 1;

--7.For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT c.customer_id, 
SUM(CASE WHEN c.exclusions != '' OR c.extras != '' THEN 1 ELSE 0 END) AS change_count,
SUM(CASE WHEN c.exclusions = '' AND c.extras = '' THEN 1 ELSE 0 END) AS no_change
FROM pizza_runner.customer_orders c
JOIN pizza_runner.runner_orders r
ON c.order_id = r.order_id
WHERE r.cancellation =''
GROUP BY c.customer_id
ORDER BY c.customer_id;

--8.How many pizzas were delivered that had both exclusions and extras?
SELECT
SUM(CASE WHEN c.exclusions!='' AND c.extras!='' THEN 1 ELSE 0 END) AS changed_pizza_count 
FROM pizza_runner.customer_orders c
JOIN pizza_runner.runner_orders r
ON c.order_id = r.order_id
WHERE r.cancellation = ''

--9. What was the total volume of pizzas ordered for each hour of the day?
SELECT date_part('hour', order_time) AS hour_ordered, COUNT(order_id)
FROM pizza_runner.customer_orders 
GROUP BY date_part('hour', order_time) 
ORDER BY hour_ordered;

--10. What was the volume of orders for each day of the week?
WITH CTE_DAY AS(
	SELECT date_part('isodow', order_time) AS day_of_week,
	COUNT(order_id) AS order_volume
	FROM pizza_runner.customer_orders 
	GROUP BY day_of_week
	order by day_of_week)
SELECT 
CASE WHEN day_of_week = 1 THEN 'Monday'
WHEN day_of_week = 2 THEN 'Tuesday'
WHEN day_of_week = 3 THEN 'Wednesday'
WHEN day_of_week = 4 THEN 'Thursday'
WHEN day_of_week = 5 THEN 'Friday'
WHEN day_of_week = 6 THEN 'Saturday'
ELSE'Sunday' END AS weekday,
order_volume
FROM CTE_DAY



