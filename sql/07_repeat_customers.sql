-- What share of customers (by customer_unique_id) placed 2 or more delivered orders?
WITH customer_share AS 
(SELECT
    COUNT(DISTINCT orders.order_id) AS n_orders,
    customer_unique_id
    
FROM orders
join customers on orders.customer_id = customers.customer_id
WHERE order_status = 'delivered'
GROUP BY customer_unique_id
)
SELECT
    ROUND(COUNT(*) FILTER (WHERE n_orders >=2) * 100 / COUNT(*) , 2) AS customer_pct
FROM customer_share