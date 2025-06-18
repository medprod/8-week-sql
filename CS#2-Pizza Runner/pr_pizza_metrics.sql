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
SELECT * FROM pizza_runner.customer_orders;
SELECT * FROM pizza_runner.runner_orders;

SELECT COUNT(order_id) AS total_pizzas_ordered
FROM pizza_runner.customer_orders;

--2.How many unique customer orders were made?

