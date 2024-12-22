--join all things
SELECT s.customer_id, s.order_date,
m.product_name, m.price, 
(CASE WHEN s.customer_id IN (SELECT mem.customer_id FROM Members mem) AND s.order_date >= mem.join_date THEN 'Y' 
ELSE 'N' END) AS 'Member'
FROM Sales s
INNER JOIN Menu m
ON s.product_id = m.product_id
LEFT JOIN Members mem
ON s.customer_id = mem.customer_id;

--rank all the things
WITH RankCTE AS(
    SELECT s.customer_id AS CustomerID, s.order_date AS OrderDate,
    m.product_name AS ProductName, m.price AS Price, 
    (CASE WHEN s.customer_id IN (SELECT mem.customer_id FROM Members mem) AND s.order_date >= mem.join_date THEN 'Y' 
    ELSE 'N' END) AS Member
    FROM Sales s
    INNER JOIN Menu m
    ON s.product_id = m.product_id
    LEFT JOIN Members mem
    ON s.customer_id = mem.customer_id
)

SELECT CustomerID, OrderDate, 
ProductName, Price, Member, 
CASE WHEN Member = 'Y' THEN RANK() OVER(PARTITION BY CustomerID, Member ORDER BY OrderDate, ProductName, Price DESC) ELSE NULL END AS 'Ranking'
FROM RankCTE;
