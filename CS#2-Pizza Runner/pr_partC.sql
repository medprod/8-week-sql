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

CREATE TEMP TABLE extras_temp(
	order_id INT,
	customer_id INT,
	pizza_id INT,
	exclusions text, 
	extras text,
	ordertime timestamp
);
INSERT INTO extras_temp (order_id, customer_id, pizza_id, exclusions, extras, ordertime)
SELECT 
  co.order_id,
  co.customer_id,
  co.pizza_id,
  co.exclusions,
  x.extras,
  co.order_time
FROM pizza_runner.customer_orders co
LEFT JOIN LATERAL unnest(string_to_array(co.extras, ',')) AS x(extras) ON TRUE;

ALTER TABLE extras_temp
ALTER column extras TYPE numeric
USING extras::numeric;

SELECT * FROM extras_temp;
SELECT * FROM pizza_runner.pizza_toppings;

--query for 2
SELECT p.topping_name, COUNT(*) AS extras_count
FROM orders_temp o
JOIN pizza_runner.pizza_toppings p ON o.extras = p.topping_id
GROUP BY o.extras, p.topping_name
ORDER BY extras_count DESC

--3.What was the most common exclusion?

CREATE TEMP TABLE exclusions_temp(
	order_id INT,
	customer_id INT,
	pizza_id INT,
	exclusions text, 
	extras text,
	ordertime timestamp
);
INSERT INTO exclusions_temp (order_id, customer_id, pizza_id, exclusions, extras, ordertime)
SELECT 
  co.order_id,
  co.customer_id,
  co.pizza_id,
  e.exclusions,
  co.extras,
  co.order_time
FROM pizza_runner.customer_orders co
LEFT JOIN LATERAL unnest(string_to_array(co.exclusions, ',')) AS e(exclusions) ON TRUE;

ALTER TABLE exclusions_temp
ALTER column exclusions TYPE numeric
USING exclusions::numeric;

SELECT * FROM exclusions_temp;

SELECT p.topping_name, COUNT(*) AS exclusions_count
FROM exclusions_temp e
JOIN pizza_runner.pizza_toppings p ON e.exclusions = p.topping_id
GROUP BY e.exclusions, p.topping_name
ORDER BY exclusions_count DESC 








