-- How much revenue and how many orders per month (delivered orders only)?

SELECT
    DATE_TRUNC('month', orders.order_purchase_timestamp) AS month,
    SUM(order_items.price) AS revenue,
    COUNT(DISTINCT orders.order_id) AS n_orders

FROM orders
JOIN order_items ON orders.order_id = order_items.order_id
WHERE orders.order_status = 'delivered'
GROUP BY month
ORDER BY month