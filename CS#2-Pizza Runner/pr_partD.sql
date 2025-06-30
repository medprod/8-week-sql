SELECT * FROM pizza_runner.runners;
SELECT * FROM pizza_runner.customer_orders;
SELECT * FROM pizza_runner.runner_orders;
SELECT * FROM pizza_runner.pizza_names;
SELECT * FROM pizza_runner.pizza_recipes;
SELECT * FROM pizza_runner.pizza_toppings;

--D. Pricing and Ratings

--1.If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
WITH total_money_cte AS(
	SELECT p.pizza_name, COUNT(*) AS total_pizzas
	FROM pizza_runner.customer_orders c
	JOIN pizza_runner.pizza_names p 
	ON c.pizza_id = p.pizza_id
	GROUP BY c.pizza_id, p.pizza_name
)
SELECT SUM(CASE WHEN pizza_name = 'Vegetarian' THEN total_pizzas * 10 
WHEN pizza_name = 'Meatlovers' THEN total_pizzas * 12 ELSE 0 END) AS total_money_made
FROM total_money_cte;





