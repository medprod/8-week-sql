SELECT * FROM pizza_runner.runners;
SELECT * FROM pizza_runner.customer_orders;
SELECT * FROM pizza_runner.runner_orders;
SELECT * FROM pizza_runner.pizza_names;
SELECT * FROM pizza_runner.pizza_recipes;
SELECT * FROM pizza_runner.pizza_toppings;

--C. Ingredient Optimisation

--1. What are the standard ingredients for each pizza?
SELECT * FROM pizza_runner.pizza_recipes;

CREATE TEMP TABLE pizza_recipes_temp(
	pizza_id INT,
	toppings text
	);
INSERT INTO pizza_recipes_temp(pizza_id, toppings)
SELECT pizza_id, unnest(string_to_array(toppings, ','))
FROM pizza_runner.pizza_recipes

ALTER TABLE pizza_recipes_temp
ALTER column toppings TYPE numeric 
USING toppings::numeric

SELECT * FROM pizza_recipes_temp
SELECT * FROM pizza_runner.pizza_toppings;

--query for 1
SELECT pt.pizza_id, pt.toppings, p.topping_name FROM pizza_recipes_temp pt
JOIN pizza_runner.pizza_toppings p ON pt.toppings = p.topping_id
ORDER BY pt.pizza_id, pt.toppings


--2.What was the most commonly added extra?
SELECT * FROM pizza_runner.customer_orders;

CREATE TEMP TABLE orders_temp(
	order_id INT,
	customer_id INT,
	pizza_id INT,
	exclusions text, 
	extras text,
	ordertime timestamp
);
INSERT INTO orders_temp(order_id, customer_id, pizza_id, exclusions, extras, ordertime)
SELECT order_id, customer_id, pizza_id, unnest(string_to_array(exclusions,',')),
unnest(string_to_array(extras,',')), order_time
FROM pizza_runner.customer_orders

ALTER TABLE orders_temp
ALTER column extras TYPE numeric
USING extras::numeric;

ALTER TABLE orders_temp
ALTER column exclusions TYPE numeric
USING exclusions::numeric;

SELECT * FROM orders_temp;
SELECT * FROM pizza_runner.pizza_toppings;

--query for 2
SELECT p.topping_name, COUNT(*) AS extras_count
FROM orders_temp o
JOIN pizza_runner.pizza_toppings p ON o.extras = p.topping_id
GROUP BY o.extras, p.topping_name
ORDER BY extras_count DESC
