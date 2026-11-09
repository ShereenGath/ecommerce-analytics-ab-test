-- Which 10 product categories bring the most revenue?
Select 
    SUM(order_items.price) as revenue,
    category.product_category_name_english as category_name,
    COUNT(DISTINCT orders.order_id) AS n_orders

from order_items
JOIN products on order_items.product_id = products.product_id
JOIN category on products.product_category_name = category.product_category_name
JOIN orders on order_items.order_id = orders.order_id

GROUP BY category_name
ORDER BY revenue DESC
LIMIT 10