SELECT
    c.id AS customer_id,
    c.full_name AS customer_name,
    o.id AS order_id,
    o.order_date,
    GROUP_CONCAT(
        CONCAT(p.name, ' (Quantity: ', oi.quantity, ', Unit Price: ', oi.price, ')') SEPARATOR ', '
    ) AS purchases,
    SUM(oi.quantity * oi.price) AS total_spent
FROM
    customers c
LEFT JOIN
    orders o ON c.id = o.customer_id
LEFT JOIN
    order_items oi ON o.id = oi.order_id
LEFT JOIN
    products p ON oi.product_id = p.id
GROUP BY
    c.id, o.id
ORDER BY
    o.order_date DESC;
