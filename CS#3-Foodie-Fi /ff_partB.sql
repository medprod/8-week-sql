SELECT * FROM foodie_fi.plans;

SELECT * FROM foodie_fi.subscriptions;

-- Part B: Data Analysis Questions

--1. How many customers has Foodie-Fi ever had?
SELECT COUNT(DISTINCT(customer_id)) AS total_customers
FROM foodie_fi.subscriptions;

--2. What is the monthly distribution of trial plan start_date values for our dataset use the start of the month as the group by value
SELECT COUNT(p.plan_id) AS total_subscriptions, date_trunc('month',s.start_date) AS month_start
FROM foodie_fi.plans p
JOIN foodie_fi.subscriptions s ON p.plan_id = s.plan_id
GROUP BY date_trunc('month',s.start_date)
ORDER BY month_start;

--3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
SELECT COUNT(p.plan_id), p.plan_name, date_trunc('month',s.start_date) AS month_start 
FROM foodie_fi.plans p
JOIN foodie_fi.subscriptions s ON p.plan_id = s.plan_id
WHERE date_part('month',s.start_date) > 2020
GROUP BY p.plan_name, month_start
ORDER BY month_start;


--4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
SELECT COUNT(*) FILTER (WHERE s.plan_id = 4) AS total_churned,
ROUND(100.0* COUNT(*) FILTER (WHERE s.plan_id = 4)/COUNT(DISTINCT s.customer_id),1) AS churn_percenatge
FROM foodie_fi.subscriptions s;

--5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

--[customer_id must only appear twice and plan_id of of first date should be 0 and second date should be 4]
WITH row_select_04 AS(
	SELECT customer_id, plan_id, start_date,
	ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY start_date) as row_num
	FROM foodie_fi.subscriptions
), 
--selects all customers who appear twice only 
churned_after_trial AS(
	SELECT customer_id FROM row_select_04
	WHERE (row_num = 1 AND plan_id = 0) OR (row_num = 2 AND plan_id = 4) 
	GROUP BY customer_id
	HAVING COUNT(*) = 2 
)
SELECT COUNT(*) AS churned_customers,
ROUND(
	100.0 * COUNT(*) / (SELECT COUNT(DISTINCT(customer_id)) FROM foodie_fi.subscriptions)
) AS churn_percentage
FROM churned_after_trial;


--6. What is the number and percentage of customer plans after their initial free trial?
WITH initial_cte AS (
	SELECT customer_id as custID, plan_id AS planID,
	start_date, 
	RANK() OVER(PARTITION BY customer_id ORDER BY plan_id) as rank_num
	FROM foodie_fi.subscriptions
	ORDER BY customer_id, plan_id
	),
rank_2 AS (
	SELECT custID, planID, start_date,rank_num
	from initial_cte WHERE rank_num = 2
)
SELECT planID, COUNT(custID) as total_customers,
ROUND(100.0*COUNT(custID)/(SELECT COUNT(DISTINCT customer_id) FROM foodie_fi.subscriptions),2) AS percentage
FROM rank_2
GROUP BY planID


--7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
WITH rank_num_cte AS(
	SELECT customer_id AS custID, plan_id AS planID, start_date,
	RANK() OVER (PARTITION BY customer_id ORDER BY start_date DESC) AS rank_num
	FROM foodie_fi.subscriptions
	WHERE start_date <= '2020-12-31'
	ORDER BY customer_id
	),
max_rank_num AS(
	SELECT custID, planID, start_date, rank_num
	FROM rank_num_cte
	WHERE rank_num=1
)
SELECT planID as plan_id, 
COUNT(custID) AS plan_customers,
ROUND(100.0*COUNT(custID)/(SELECT COUNT(DISTINCT customer_id) FROM foodie_fi.subscriptions),2) AS percentage
FROM max_rank_num
GROUP BY plan_id;

--8.How many customers have upgraded to an annual plan in 2020?
SELECT COUNT(customer_id) FROM foodie_fi.subscriptions
WHERE date_part('year', start_date)<='2020' AND plan_id = 3
--OR
WITH cte_2020 AS(
	SELECT customer_id, plan_id, start_date,
	RANK() OVER(PARTITION BY customer_id ORDER BY start_date DESC) as rank_num
	FROM foodie_fi.subscriptions
	WHERE date_part('year', start_date)<='2020')

SELECT COUNT(customer_id)
FROM cte_2020
WHERE rank_num = 1 AND plan_id = 3

--9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

WITH initial_date_cte AS (
	SELECT customer_id, plan_id, 
	start_date AS initial_date
	FROM foodie_fi.subscriptions
	WHERE plan_id = 0
),
final_date_cte AS (
	SELECT customer_id, plan_id, 
	start_date AS final_date
	FROM foodie_fi.subscriptions
	WHERE plan_id = 3
)
SELECT AVG(f.final_date - i.initial_date) AS days_between
FROM final_date_cte f
JOIN initial_date_cte i ON f.customer_id = i.customer_id

--10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)


--11.How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
SELECT * FROM foodie_fi.plans;

SELECT * FROM foodie_fi.subscriptions;

WITH CTE_rank AS(
	SELECT customer_id, plan_id, start_date, 
	RANK() OVER(PARTITION BY customer_id ORDER BY start_date) AS rank_num
	FROM foodie_fi.subscriptions
	WHERE date_part('year', start_date) <= 2020 
	AND plan_id IN (1,2)
),
prevcurr_plan AS(
	SELECT curr.customer_id
	FROM CTE_rank curr
	JOIN CTE_rank prev
	ON curr.customer_id = prev.customer_id
	AND curr.rank_num = prev.rank_num + 1
	WHERE curr.plan_id = 1 AND prev.plan_id = 2
)
SELECT COUNT(DISTINCT customer_id) AS customers_downgraded
FROM prevcurr_plan;



