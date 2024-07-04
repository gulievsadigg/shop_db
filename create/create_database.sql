
CREATE DATABASE IF NOT EXISTS abc_shop;

USE abc_shop;

CREATE TABLE IF NOT EXISTS customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    last_login TIMESTAMP,
    password VARCHAR(255) NOT NULL,
    address TEXT,
    telephone VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    supplier VARCHAR(255),
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(255),
    images TEXT,
    tags TEXT,
    comments TEXT,
    available_quantity INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    description TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    status ENUM('active', 'returned') DEFAULT 'active',
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE IF NOT EXISTS returned_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_item_id INT,
    return_date DATE,
    reason TEXT,
    return_quantity INT,
    FOREIGN KEY (order_item_id) REFERENCES order_items(id)
);

DELIMITER $$

CREATE TRIGGER update_product_quantity_on_order
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE product_quantity INT;
    
    SET product_quantity = NEW.quantity;
    
    UPDATE products
    SET available_quantity = available_quantity - product_quantity
    WHERE id = NEW.product_id;
END$$

CREATE TRIGGER update_product_quantity_on_return
AFTER INSERT ON returned_items
FOR EACH ROW
BEGIN
    DECLARE order_item_quantity INT;
    
    IF (SELECT quantity FROM order_items WHERE id = NEW.order_item_id) > 0 THEN
        SET order_item_quantity = NEW.return_quantity;

        UPDATE products
        JOIN order_items ON products.id = order_items.product_id
        SET products.available_quantity = products.available_quantity + order_item_quantity
        WHERE order_items.id = NEW.order_item_id;

        UPDATE order_items
        SET quantity = quantity - order_item_quantity
        WHERE id = NEW.order_item_id;

        IF (SELECT quantity FROM order_items WHERE id = NEW.order_item_id) <= 0 THEN
            UPDATE order_items
            SET status = 'returned'
            WHERE id = NEW.order_item_id;
        END IF;
    END IF;
END$$

DELIMITER ;