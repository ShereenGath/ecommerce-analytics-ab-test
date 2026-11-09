-- What share of delivered orders arrive later than the estimated date?
WITH labeled AS (
    SELECT
        order_id,
        CASE WHEN order_delivered_customer_date::date - order_estimated_delivery_date::date > 0 THEN 'late'
             WHEN order_delivered_customer_date::date - order_estimated_delivery_date::date = 0 THEN 'on_time'
             ELSE 'early' END AS delivery_status
    FROM orders
    WHERE order_status = 'delivered' AND order_delivered_customer_date IS NOT NULL
)
SELECT
    delivery_status,
    COUNT(*) AS n_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS share_pct
FROM labeled
GROUP BY delivery_status
ORDER BY n_orders DESC