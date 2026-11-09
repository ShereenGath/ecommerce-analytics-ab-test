-- What is the average delivery time in days for each customer state?
SELECT 
    ROUND(AVG(DATEDIFF('day', orders.order_purchase_timestamp, orders.order_delivered_customer_date)), 1) AS avg_delivery_time,
    ROUND(MEDIAN(DATEDIFF('day', orders.order_purchase_timestamp, orders.order_delivered_customer_date)), 1) AS median_delivery_time,
    customers.customer_state as state,
    COUNT(DISTINCT orders.order_id) AS n_orders

FROM orders
JOIN customers on orders.customer_id = customers.customer_id
WHERE orders.order_status = 'delivered' AND orders.order_delivered_customer_date IS NOT NULL
GROUP BY state
ORDER BY avg_delivery_time, median_delivery_time