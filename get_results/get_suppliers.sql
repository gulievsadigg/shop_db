SELECT
    p.supplier AS supplier_name,
    COUNT(p.id) AS total_products,
    COALESCE(SUM(oi.quantity), 0) AS total_sold_quantity,
    SUM(p.available_quantity) AS current_stock_quantity
FROM
    products p
LEFT JOIN
    order_items oi ON p.id = oi.product_id
GROUP BY
    p.supplier
ORDER BY
    supplier_name;
