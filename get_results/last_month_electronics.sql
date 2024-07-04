SELECT
    p.name AS product_name,
    p.id AS product_id,
    SUM(oi.quantity) AS total_sold,
    SUM(oi.price * oi.quantity) AS total_revenue
FROM
    order_items oi
JOIN
    orders o ON oi.order_id = o.id
JOIN
    products p ON oi.product_id = p.id
WHERE
    p.category = 'Electronics' AND
    o.order_date >= DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m-01') AND
    o.order_date < DATE_FORMAT(NOW(), '%Y-%m-01')
GROUP BY
    p.id, p.name
ORDER BY
    total_sold DESC;
