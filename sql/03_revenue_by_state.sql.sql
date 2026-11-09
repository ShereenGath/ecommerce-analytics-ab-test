-- How many orders and what average order value does each customer state have?

SELECT
    customers.customer_state,
    ROUND(SUM(order_items.price)/COUNT(DISTINCT order_items.order_id), 2) AS avg_order_value,
    ROUND(SUM(order_items.price), 0) AS revenue,
    COUNT(DISTINCT orders.order_id) AS n_orders

FROM orders
join customers on orders.customer_id = customers.customer_id
join order_items on orders.order_id = order_items.order_id
WHERE orders.order_status = 'delivered'
GROUP BY customers.customer_state
ORDER BY revenue DESC