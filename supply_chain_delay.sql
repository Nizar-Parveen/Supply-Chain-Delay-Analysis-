create database supply_chain;
use supply_chain;

-- =========================
-- 1. CREATE TABLES
-- =========================

CREATE TABLE suppliers (
  supplier_id VARCHAR(10),
  supplier_name VARCHAR(50),
  location VARCHAR(50)
);

CREATE TABLE orders (
  order_id INT,
  customer_id VARCHAR(10),
  order_date DATE,
  expected_delivery_date DATE
);

CREATE TABLE shipments (
  shipment_id INT,
  order_id INT,
  supplier_id VARCHAR(10),
  shipped_date DATE,
  delivered_date DATE
);

-- =========================
-- 2. BASE JOIN + DELAY
-- =========================

SELECT 
  s.shipment_id,
  s.order_id,
  sup.supplier_name,
  sup.location,
  o.order_date,
  o.expected_delivery_date,
  s.shipped_date,
  s.delivered_date,
  DATEDIFF(s.delivered_date, o.expected_delivery_date) AS delay_days
FROM shipments s
JOIN orders o ON s.order_id = o.order_id
JOIN suppliers sup ON s.supplier_id = sup.supplier_id;

-- =========================
-- 3. ONLY DELAYED SHIPMENTS
-- =========================

SELECT *
FROM (
  SELECT 
    s.shipment_id,
    sup.supplier_name,
    DATEDIFF(s.delivered_date, o.expected_delivery_date) AS delay_days
  FROM shipments s
  JOIN orders o ON s.order_id = o.order_id
  JOIN suppliers sup ON s.supplier_id = sup.supplier_id
) t
WHERE delay_days > 0;

-- =========================
-- 4. SUPPLIER-WISE DELAY TREND
-- =========================

SELECT 
  sup.supplier_name,
  COUNT(*) AS total_shipments,
  AVG(DATEDIFF(s.delivered_date, o.expected_delivery_date)) AS avg_delay_days,
  SUM(CASE WHEN DATEDIFF(s.delivered_date, o.expected_delivery_date) > 0 THEN 1 ELSE 0 END) AS delayed_shipments
FROM shipments s
JOIN orders o ON s.order_id = o.order_id
JOIN suppliers sup ON s.supplier_id = sup.supplier_id
GROUP BY sup.supplier_name
ORDER BY avg_delay_days DESC;

-- =========================
-- 5. LOCATION-WISE DELAY
-- =========================

SELECT 
  sup.location,
  AVG(DATEDIFF(s.delivered_date, o.expected_delivery_date)) AS avg_delay_days
FROM shipments s
JOIN orders o ON s.order_id = o.order_id
JOIN suppliers sup ON s.supplier_id = sup.supplier_id
GROUP BY sup.location
ORDER BY avg_delay_days DESC;

-- =========================
-- 6. MONTHLY DELAY TREND
-- =========================

SELECT 
  DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
  AVG(DATEDIFF(s.delivered_date, o.expected_delivery_date)) AS avg_delay
FROM shipments s
JOIN orders o ON s.order_id = o.order_id
GROUP BY order_month
ORDER BY order_month;

-- =========================
-- 7. HIGH-RISK SUPPLIERS
-- =========================

SELECT 
  sup.supplier_name,
  AVG(DATEDIFF(s.delivered_date, o.expected_delivery_date)) AS avg_delay
FROM shipments s
JOIN orders o ON s.order_id = o.order_id
JOIN suppliers sup ON s.supplier_id = sup.supplier_id
GROUP BY sup.supplier_name
HAVING avg_delay > 3;
