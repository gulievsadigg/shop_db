SELECT
    p.id AS product_id,
    p.name AS product_name,
    p.supplier AS supplier_name,
    SUM(oi.quantity) AS total_sold_quantity
FROM
    products p
JOIN
    order_items oi ON p.id = oi.product_id
GROUP BY
    p.id, p.name, p.supplier
ORDER BY
    total_sold_quantity DESC
LIMIT 10;
