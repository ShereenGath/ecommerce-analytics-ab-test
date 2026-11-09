-- Who are the top 3 sellers by revenue in each seller state?
WITH seller_revenue AS 
( SELECT
    s.seller_state,
    s.seller_id,
    SUM(order_items.price) AS revenue,
    COUNT(DISTINCT orders.order_id) AS n_orders
FROM sellers s
join order_items on order_items.seller_id = s.seller_id
join orders on orders.order_id = order_items.order_id
WHERE orders.order_status = 'delivered'
GROUP BY s.seller_state, s.seller_id
),
ranked AS (
    SELECT
        seller_state,
        seller_id,
        revenue,
        n_orders,
        RANK() OVER (PARTITION BY seller_state ORDER BY revenue DESC) AS seller_rank
    FROM seller_revenue

)
SELECT *
FROM ranked
WHERE seller_rank <= 3
ORDER BY seller_state, seller_rank