--1. What is the total amount each customer spent at the restaurant?
SELECT s.customer_id AS 'Customer ID', 
CONCAT('$', SUM(m.price)) AS 'Total Amount Spent'
FROM Sales s
JOIN Menu m 
ON s.product_id = m.product_id
GROUP BY s.customer_id;

--2. How many days has each customer visited the restaurant?
SELECT s.customer_id AS 'Customer ID', 
COUNT(DISTINCT s.order_date) AS 'Number of Days Visited'
FROM Sales s
GROUP BY s.customer_id;

--3.What was the first item from the menu purchased by each customer?
SELECT s.customer_id, m.product_name, s.order_date
FROM Sales s
JOIN Menu m
ON s.product_id = m.product_id
WHERE s.order_date IN (SELECT MIN(s.order_date) FROM Sales s)
GROUP BY s.customer_id, m.product_name, s.order_date
ORDER BY s.customer_id;

--4.What is the most purchased item on the menu and how many times was it purchased by all customers?
--in sql server, top(1) is same as LIMIT in mySQL.
SELECT TOP(1) m.product_name AS 'Most Purchased Item', COUNT(s.product_id) AS 'Number of Times Purchased'
FROM Menu m
JOIN Sales s ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY COUNT(s.product_id) DESC;

--5.Which item was the most popular for each customer?
SELECT * FROM Sales;
SELECT * FROM Menu;
SELECT * FROM Members;

CREATE VIEW MostPopularItem AS
SELECT 
    s.customer_id AS CustomerID, 
    m.product_name AS ItemName, 
    COUNT(m.product_name) AS TimesPurchased
FROM Sales s
JOIN Menu m
ON s.product_id = m.product_id
GROUP BY customer_id,m.product_name;

SELECT CustomerID as 'Customer', ItemName as 'Most Popular Item'
FROM MostPopularItem
WHERE TimesPurchased = (SELECT MAX(TimesPurchased) FROM MostPopularItem WHERE s.customer_id = CustomerID)

--6.Which item was purchased first by the customer after they became a member?






