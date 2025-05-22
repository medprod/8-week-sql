SELECT * FROM foodie_fi.plans;

SELECT * FROM foodie_fi.subscriptions;

-- Part B: Data Analysis Questions

--1. How many customers has Foodie-Fi ever had?
SELECT COUNT(DISTINCT(customer_id)) AS total_customers
FROM foodie_fi.subscriptions;

--2. What is the monthly distribution of trial plan start_date values for our dataset - 
-- use the start of the month as the group by value