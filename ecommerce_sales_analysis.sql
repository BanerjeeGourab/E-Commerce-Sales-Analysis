CREATE DATABASE IF NOT EXISTS ecommerce_sales_analysis;
USE ecommerce_sales_analysis;

CREATE TABLE IF NOT EXISTS sales_orders (
    order_id VARCHAR(40) NOT NULL PRIMARY KEY,
    order_date DATETIME NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(60) NOT NULL,
    region VARCHAR(40) NOT NULL,
    customer_id VARCHAR(40) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    status ENUM('Shipped','Pending','Cancelled') NOT NULL,
    sales_representative VARCHAR(80) NOT NULL,
    CONSTRAINT chk_quantity_positive CHECK (quantity > 0),
    CONSTRAINT chk_unit_price_positive CHECK (unit_price > 0)
);

-- Query 1: Dataset size, date range, and order status counts
SELECT
    COUNT(*) AS total_order_records,
    COUNT(DISTINCT customer_id) AS unique_customers,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM sales_orders;

SELECT status, COUNT(*) AS order_count,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM sales_orders), 2) AS pct_of_orders
FROM sales_orders
GROUP BY status
ORDER BY order_count DESC;

-- Query 2: Executive KPIs
SELECT
    COUNT(*) AS total_orders,
    SUM(status = 'Shipped') AS shipped_orders,
    SUM(status = 'Pending') AS pending_orders,
    SUM(status = 'Cancelled') AS cancelled_orders,
    SUM(CASE WHEN status = 'Shipped' THEN quantity ELSE 0 END) AS shipped_units,
    ROUND(SUM(CASE WHEN status = 'Shipped' THEN quantity * unit_price ELSE 0 END), 2) AS recognized_revenue,
    ROUND(
      SUM(CASE WHEN status = 'Shipped' THEN quantity * unit_price ELSE 0 END)
      / NULLIF(SUM(status = 'Shipped'), 0), 2
    ) AS average_shipped_order_value,
    ROUND(100.0 * SUM(status = 'Cancelled') / COUNT(*), 2) AS cancellation_rate_pct
FROM sales_orders;

-- Query 3: Sales performance by product category (shipped orders only)
SELECT category,
       COUNT(*) AS shipped_orders,
       SUM(quantity) AS units_sold,
       ROUND(SUM(quantity * unit_price), 2) AS recognized_revenue
FROM sales_orders
WHERE status = 'Shipped'
GROUP BY category
ORDER BY recognized_revenue DESC;

-- Query 4: Sales performance by region
SELECT region,
       COUNT(*) AS shipped_orders,
       SUM(quantity) AS units_sold,
       ROUND(SUM(quantity * unit_price), 2) AS recognized_revenue
FROM sales_orders
WHERE status = 'Shipped'
GROUP BY region
ORDER BY recognized_revenue DESC;

-- Query 5: Monthly revenue trend
SELECT DATE_FORMAT(order_date, '%Y-%m') AS order_month,
       COUNT(*) AS shipped_orders,
       SUM(quantity) AS units_sold,
       ROUND(SUM(quantity * unit_price), 2) AS recognized_revenue
FROM sales_orders
WHERE status = 'Shipped'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_month;

-- Query 6: Sales representative performance
SELECT sales_representative,
       COUNT(*) AS shipped_orders,
       SUM(quantity) AS units_sold,
       ROUND(SUM(quantity * unit_price), 2) AS recognized_revenue,
       ROUND(SUM(quantity * unit_price) / NULLIF(COUNT(*), 0), 2) AS average_order_value
FROM sales_orders
WHERE status = 'Shipped'
GROUP BY sales_representative
ORDER BY recognized_revenue DESC;

-- Query 7: Top 10 products by recognized revenue
SELECT product_name,
       SUM(quantity) AS units_sold,
       COUNT(*) AS shipped_orders,
       ROUND(SUM(quantity * unit_price), 2) AS recognized_revenue
FROM sales_orders
WHERE status = 'Shipped'
GROUP BY product_name
ORDER BY recognized_revenue DESC
LIMIT 10;

-- Query 8: Customers with more than one shipped order
SELECT customer_id,
       COUNT(*) AS shipped_orders,
       SUM(quantity) AS units_purchased,
       ROUND(SUM(quantity * unit_price), 2) AS recognized_revenue
FROM sales_orders
WHERE status = 'Shipped'
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY recognized_revenue DESC;

-- Query 9: Data quality checks
SELECT
    SUM(order_id IS NULL OR TRIM(order_id) = '') AS missing_order_ids,
    SUM(order_date IS NULL) AS missing_order_dates,
    SUM(product_name IS NULL OR TRIM(product_name) = '') AS missing_products,
    SUM(customer_id IS NULL OR TRIM(customer_id) = '') AS missing_customer_ids,
    SUM(quantity <= 0) AS invalid_quantities,
    SUM(unit_price <= 0) AS invalid_unit_prices,
    COUNT(*) - COUNT(DISTINCT order_id) AS duplicate_order_ids
FROM sales_orders;

-- Query 10: Order value by status (diagnostic; not all of this is recognized revenue)
SELECT status,
       COUNT(*) AS order_count,
       ROUND(SUM(quantity * unit_price), 2) AS order_value
FROM sales_orders
GROUP BY status
ORDER BY order_count DESC;
