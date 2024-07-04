SELECT
    ri.id AS return_id,
    ri.return_date,
    ri.reason,
    ri.return_quantity,
    oi.id AS order_item_id,
    oi.order_id,
    oi.product_id,
    oi.quantity AS order_quantity,
    oi.price AS order_price,
    p.name AS product_name,
    p.supplier AS product_supplier,
    p.description AS product_description,
    p.price AS product_price,
    o.customer_id,
    o.order_date,
    o.description AS order_description,
    c.full_name AS customer_name,
    c.email AS customer_email,
    c.address AS customer_address,
    c.telephone AS customer_telephone
FROM
    returned_items ri
JOIN
    order_items oi ON ri.order_item_id = oi.id
JOIN
    products p ON oi.product_id = p.id
JOIN
    orders o ON oi.order_id = o.id
JOIN
    customers c ON o.customer_id = c.id
ORDER BY
    ri.return_date DESC;
