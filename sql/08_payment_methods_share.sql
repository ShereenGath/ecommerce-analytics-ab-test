-- What share of orders uses each payment method, and what is the average number of instalments?
WITH payment_share AS
(SELECT
    COUNT(DISTINCT orders.order_id) AS n_orders,
    payments.payment_type,
    ROUND(AVG(payments.payment_installments),2) AS avg_install
    
FROM orders
join payments on orders.order_id = payments.order_id
WHERE orders.order_status = 'delivered'
GROUP BY payments.payment_type
)
SELECT
    n_orders,
    ROUND(n_orders * 100.0 / SUM(n_orders) OVER (), 2) AS payment_pct,
    payment_type,
    avg_install
FROM payment_share
ORDER BY payment_pct DESC

