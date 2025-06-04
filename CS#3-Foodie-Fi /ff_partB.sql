SELECT * FROM foodie_fi.plans LIMIT 10;

SELECT * FROM foodie_fi.subscriptions;

-- Part B: Data Analysis Questions

--1. How many customers has Foodie-Fi ever had?
SELECT COUNT(DISTINCT(customer_id)) AS total_customers
FROM foodie_fi.subscriptions;

--2. What is the monthly distribution of trial plan start_date values for our dataset 
-- use the start of the month as the group by value
SELECT COUNT(p.plan_id) AS total_subscriptions, date_trunc('month',s.start_date) AS month_start
FROM foodie_fi.plans p
JOIN foodie_fi.subscriptions s ON p.plan_id = s.plan_id
GROUP BY date_trunc('month',s.start_date)
ORDER BY month_start;

--3. What plan start_date values occur after the year 2020 for our dataset? 
--Show the breakdown by count of events for each plan_name
SELECT COUNT(p.plan_id), p.plan_name, date_trunc('month',s.start_date) AS month_start 
FROM foodie_fi.plans p
JOIN foodie_fi.subscriptions s ON p.plan_id = s.plan_id
WHERE date_part('month',s.start_date) > 2020
GROUP BY p.plan_name, month_start
ORDER BY month_start;


--4. What is the customer count and percentage of customers who have churned rounded 
--to 1 decimal place?
SELECT COUNT(*) FILTER (WHERE s.plan_id = 4) AS total_churned,
ROUND(100.0* COUNT(*) FILTER (WHERE s.plan_id = 4)/COUNT(DISTINCT s.customer_id),1) AS churn_percenatge
FROM foodie_fi.subscriptions s

--5. How many customers have churned straight after their initial free trial - 
--what percentage is this rounded to the nearest whole number?

--customer_id must only appear twice? and plan_id of that once should be 0 and then 4

SELECT * FROM foodie_fi.plans;

SELECT * FROM foodie_fi.subscriptions;




