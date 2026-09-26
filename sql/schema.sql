
USE client_bi;




CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    segment VARCHAR(30),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code INT,
    region VARCHAR(20)
);



CREATE TABLE products (
    product_id VARCHAR(30) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(50),
    sub_category VARCHAR(50)
);




CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE NOT NULL,
    ship_date DATE NOT NULL,
    ship_mode VARCHAR(30),
    customer_id VARCHAR(20),

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);




CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(30) NOT NULL,
    sales DECIMAL(12,2),
    quantity INT,
    discount DECIMAL(5,4),
    profit DECIMAL(12,2),

    CONSTRAINT fk_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

show tables;

DESCRIBE customers;

DESCRIBE products;

DESCRIBE orders;

DESCRIBE order_items;

USE client_bi;

SELECT COUNT(*) AS customers
FROM customers;

SELECT COUNT(*) AS products
FROM products;

SELECT COUNT(*) AS orders
FROM orders;

SELECT COUNT(*) AS order_items
FROM order_items;

SELECT *
FROM customers
LIMIT 5;

SELECT *
FROM products
LIMIT 5;

SELECT *
FROM orders
LIMIT 5;

SELECT *
FROM order_items
LIMIT 5;

USE client_bi;

-- ============================================
-- 1. OVERALL BUSINESS PERFORMANCE
-- ============================================

SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        (SUM(profit) / SUM(sales)) * 100,
        2
    ) AS profit_margin
FROM order_items;

-- ============================================
-- 2. REGIONAL PERFORMANCE
-- ============================================

SELECT
    o_region.region,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.sales), 2) AS total_sales,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(
        (SUM(oi.profit) / SUM(oi.sales)) * 100,
        2
    ) AS profit_margin
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN customers o_region
    ON o.customer_id = o_region.customer_id
GROUP BY o_region.region
ORDER BY total_sales DESC;

-- ============================================
-- 3. CATEGORY PERFORMANCE
-- ============================================

SELECT
    p.category,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.sales), 2) AS total_sales,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(
        (SUM(oi.profit) / SUM(oi.sales)) * 100,
        2
    ) AS profit_margin
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;

-- ============================================
-- 4. TOP 10 PRODUCTS
-- ============================================

SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.sales), 2) AS total_sales,
    ROUND(SUM(oi.profit), 2) AS total_profit
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY total_sales DESC
LIMIT 10;

-- ============================================
-- 5. TOP CUSTOMERS BY SALES
-- ============================================

SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    c.region,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.sales), 2) AS total_sales,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(
        (SUM(oi.profit) / SUM(oi.sales)) * 100,
        2
    ) AS profit_margin
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.segment,
    c.region
ORDER BY total_sales DESC
LIMIT 10;

-- ============================================
-- 6. DISCOUNT VS PROFITABILITY
-- ============================================

USE client_bi;

SELECT
    CASE
        WHEN discount = 0 THEN '0%'
        WHEN discount <= 0.10 THEN '1-10%'
        WHEN discount <= 0.20 THEN '11-20%'
        WHEN discount <= 0.30 THEN '21-30%'
        WHEN discount <= 0.50 THEN '31-50%'
        ELSE 'Above 50%'
    END AS discount_band,

    COUNT(*) AS order_items,

    ROUND(SUM(sales), 2) AS total_sales,

    ROUND(SUM(profit), 2) AS total_profit,

    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin

FROM order_items

GROUP BY
    CASE
        WHEN discount = 0 THEN '0%'
        WHEN discount <= 0.10 THEN '1-10%'
        WHEN discount <= 0.20 THEN '11-20%'
        WHEN discount <= 0.30 THEN '21-30%'
        WHEN discount <= 0.50 THEN '31-50%'
        ELSE 'Above 50%'
    END

ORDER BY
    MIN(discount);
    
-- ============================================
-- 7. MONTHLY SALES AND PROFIT TREND
-- ============================================    

USE client_bi;

SELECT
    YEAR(o.order_date) AS order_year,
    MONTH(o.order_date) AS order_month,
    ROUND(SUM(oi.sales), 2) AS total_sales,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(
        SUM(oi.profit) / NULLIF(SUM(oi.sales), 0) * 100,
        2
    ) AS profit_margin
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date)
ORDER BY
    YEAR(o.order_date),
    MONTH(o.order_date);

    
    
