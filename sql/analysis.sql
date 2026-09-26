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
        (SUM(profit) / SUM(sales)) * 100,
        2
    ) AS profit_margin

FROM order_items

GROUP BY discount_band

ORDER BY
    MIN(discount);

-- ============================================
-- 7. MONTHLY SALES AND PROFIT TREND
-- ============================================

SELECT
    YEAR(o.order_date) AS order_year,
    MONTH(o.order_date) AS order_month,
    DATE_FORMAT(o.order_date, '%Y-%m') AS year_month,

    ROUND(SUM(oi.sales), 2) AS total_sales,
    ROUND(SUM(oi.profit), 2) AS total_profit,

    ROUND(
        (SUM(oi.profit) / SUM(oi.sales)) * 100,
        2
    ) AS profit_margin

FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id

GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date),
    DATE_FORMAT(o.order_date, '%Y-%m')

ORDER BY
    order_year,
    order_month;