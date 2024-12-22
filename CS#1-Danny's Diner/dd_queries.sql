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
WITH MostPopularItem AS(
    SELECT 
    s.customer_id AS CustomerID, 
    m.product_name AS ItemName, 
    COUNT(m.product_name) AS TimesPurchased
    FROM Sales s
    JOIN Menu m
    ON s.product_id = m.product_id
    GROUP BY customer_id,m.product_name
)

SELECT CustomerID, ItemName
FROM(
    SELECT 
    CustomerID, 
    ItemName, 
    RANK() OVER(PARTITION BY CustomerID ORDER BY TimesPurchased DESC) AS RowRank
    FROM MostPopularItem) RankedResults
WHERE RowRank = 1
ORDER BY CustomerID;


--6.Which item was purchased first by the customer after they became a member?
WITH FirstBought AS (
    SELECT s.customer_id AS CustomerID,
    m.product_name AS ProductName,
    s.order_date AS OrderDate,
    mem.join_date AS JoinedDate
    FROM Sales s
    JOIN Menu m ON s.product_id = m.product_id
    JOIN Members mem ON s.customer_id = mem.customer_id
    WHERE s.order_date >= mem.join_date
)

SELECT CustomerID, ProductName FROM
    (SELECT CustomerID, ProductName, 
    RANK() OVER(PARTITION BY CustomerID ORDER BY OrderDate ASC) AS RowRank 
    FROM FirstBought) RankedResults
WHERE RowRank = 1
ORDER BY CustomerID;


--7.Which item was purchased just before the customer became a member?
WITH BeforeBought AS (
    SELECT s.customer_id AS CustomerID,
    m.product_name AS ProductName,
    s.order_date AS OrderDate,
    mem.join_date AS JoinedDate
    FROM Sales s
    JOIN Menu m ON s.product_id = m.product_id
    JOIN Members mem ON s.customer_id = mem.customer_id
    WHERE s.order_date < mem.join_date
)

SELECT CustomerID, ProductName
FROM (
    SELECT CustomerID, ProductName,
    RANK() OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC) AS RowRank
    FROM BeforeBought) RankedResults
WHERE RowRank=1
ORDER BY CustomerID;

--8.What is the total items and amount spent for each member before they became a member?
WITH TotalSummary AS(
    SELECT s.customer_id AS customerID, 
    COUNT(s.product_id) AS TotalItems,
    SUM(m.price) AS AmountSpent,
    s.order_date AS DateOrdered,
    mem.join_date AS JoinedDate
    FROM Sales s 
    JOIN Menu m ON s.product_id = m.product_id
    JOIN Members mem ON s.customer_id = mem.customer_id
    GROUP BY s.customer_id,s.order_date,mem.join_date
    HAVING s.order_date < mem.join_date
)

SELECT customerID, 
SUM(TotalItems) AS 'Total Items', 
SUM(AmountSpent) AS 'Amount Spent'
FROM TotalSummary
GROUP BY customerID;

--9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT s.customer_id, 
SUM(CASE WHEN m.product_id = 1 THEN m.price * 20 ELSE m.price * 10 END) AS 'Customer Points'
FROM Sales s
JOIN Menu m 
ON s.product_id = m.product_id
GROUP BY s.customer_id;

--10.In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
WITH TotalPoints AS(
    SELECT s.customer_id AS CustomerID,s.order_date AS OrderDate,
    SUM(CASE 
        WHEN s.order_date BETWEEN mem.join_date AND DATEADD(day, 6, mem.join_date) THEN m.price * 20
        WHEN s.order_date NOT BETWEEN mem.join_date AND DATEADD(day, 6, mem.join_date) AND m.product_id = 1 THEN m.price * 20
        ELSE m.price * 10 END) AS CustomerPoints
    FROM Sales s
    JOIN Menu m 
    ON s.product_id = m.product_id 
    JOIN Members mem
    ON s.customer_id = mem.customer_id
    GROUP BY s.customer_id,s.order_date
    HAVING MONTH(s.order_date) = 1)

SELECT CustomerID, SUM(CustomerPoints) AS 'Total Customer Points'
FROM TotalPoints
GROUP BY CustomerID;








