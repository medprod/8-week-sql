--this query creates tables and inserts data into table.
CREATE SCHEMA Dannys_Diner;
-- SET search_path = Dannys_Diner;

--rerunning purposes
DROP TABLE Sales;
DROP TABLE Members;
DROP TABLE Menu;

CREATE TABLE Sales(
    customer_id VARCHAR(1),
    order_date DATE,
    product_id INTEGER
);

CREATE TABLE Members(
    customer_id VARCHAR(1),
    join_date DATE
);

CREATE TABLE Menu(
    product_id INTEGER,
    product_name VARCHAR(5),
    price INTEGER
);

INSERT INTO Sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');

INSERT INTO Menu("product_id", "product_name", "price")
VALUES('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');

INSERT INTO Members("customer_id", "join_date")
VALUES('A', '2021-01-07'),
  ('B', '2021-01-09');

SELECT * FROM Sales;
SELECT * FROM Menu;
SELECT * FROM Members;

--1. What is the total amount each customer spent at the restaurant?
SELECT s.customer_id AS 'Customer ID', SUM(m.price) AS 'Total Amount Spent'
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
SELECT s.customer_id, m.product_name AS 'Most Purchased Item', COUNT(s.product_id) AS 'Number of Times Purchased'
FROM Menu m
JOIN Sales s ON s.product_id = m.product_id
GROUP BY s.customer_id, m.product_name
ORDER BY COUNT(s.product_id) DESC;




