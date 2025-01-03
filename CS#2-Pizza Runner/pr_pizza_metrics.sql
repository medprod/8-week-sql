SELECT * FROM runners;
SELECT * FROM customer_orders;
SELECT * FROM runner_orders;
SELECT * FROM pizza_names;
SELECT * FROM pizza_recipes;
SELECT * FROM pizza_toppings;

--How many pizzas were ordered?
SELECT COUNT(order_id) AS 'Total Pizzas Ordered'
FROM customer_orders;

--How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS 'Total Unique Customer Orders'
FROM customer_orders;

--How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(order_id) AS 'Number of Successful Orders'
FROM runner_orders
GROUP BY runner_id;

--How many of each type of pizza was delivered?
SELECT c.pizza_id, COUNT(c.order_id) AS 'Number of Pizzas Delivered'
FROM customer_orders c
GROUP BY pizza_id;

SELECT * FROM customer_orders;
SELECT * FROM runner_orders;
SELECT * FROM pizza_names;

--How many Vegetarian and Meatlovers were ordered by each customer?
SELECT p.pizza_name, c.customer_id,
COUNT(c.order_id) AS 'Number of Pizzas Ordered'
FROM customer_orders c
JOIN pizza_names p ON c.pizza_id = p.pizza_id
GROUP BY c.customer_id, p.pizza_name