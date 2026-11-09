-- Is the average review score lower for late orders than for on-time orders?
WITH labeled AS (
    SELECT
        orders.order_id,
        CASE WHEN order_delivered_customer_date::date - order_estimated_delivery_date::date > 0 THEN 'late'
             WHEN order_delivered_customer_date::date - order_estimated_delivery_date::date = 0 THEN 'on_time'
             ELSE 'early' END AS delivery_status,
             reviews.review_score
    FROM orders
    join reviews on orders.order_id = reviews.order_id
    WHERE order_status = 'delivered' AND order_delivered_customer_date IS NOT NULL
)
SELECT
    delivery_status,
    COUNT(*) AS n_reviews,
    ROUND(AVG(review_score), 1) AS avg_review_score 
FROM labeled
GROUP BY delivery_status
ORDER BY n_reviews DESC