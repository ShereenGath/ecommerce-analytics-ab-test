-- How much has the business earned in total so far? And how fast is it growing?

WITH monthly_revenue AS
(SELECT
    DATE_TRUNC('month', orders.order_purchase_timestamp) AS month,
    SUM(order_items.price) AS revenue,
FROM orders
JOIN order_items ON orders.order_id = order_items.order_id
WHERE orders.order_status = 'delivered'
GROUP BY month
ORDER BY month
)
SELECT
    month,
    revenue,
    SUM(revenue) OVER (ORDER BY month) AS running_total,
FROM monthly_revenue
ORDER BY month