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

SELECT s.customer_id, s.order_date,
m.product_name, m.price, 
(CASE WHEN s.customer_id IN (SELECT mem.customer_id FROM Members mem) AND s.order_date >= mem.join_date THEN 'Y' 
ELSE 'N' END) AS 'Member'
FROM Sales s
INNER JOIN Menu m
ON s.product_id = m.product_id
LEFT JOIN Members mem
ON s.customer_id = mem.customer_id;
