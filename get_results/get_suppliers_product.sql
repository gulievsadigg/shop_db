SELECT
    p.supplier AS supplier_name,
    p.id AS product_id,
    p.name AS product_name,
    COALESCE(SUM(oi.quantity), 0) AS total_sold_quantity,
    COALESCE(SUM(ri.return_quantity), 0) AS total_returned_quantity,
    p.available_quantity AS current_stock_quantity
FROM
    products p
LEFT JOIN
    order_items oi ON p.id = oi.product_id
LEFT JOIN
    returned_items ri ON oi.id = ri.order_item_id
GROUP BY
    p.supplier, p.id, p.name
ORDER BY
    supplier_name, product_name;
