-- Card: Ops Q5: On-Time Delivery Rate
-- Card ID: 67
-- Display: table
-- Dashboard: Operations Dashboard
-- Description: None
-- Database ID: 2
--
-- Operations Dashboard Q5: On-Time Delivery Rate (delivered orders)
-- On-time = delivered_date <= estimated_date.
-- Source: olist_raw.olist_orders
WITH delivered AS (
  SELECT
    order_id,
    CASE
      WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 1
      ELSE 0
    END AS is_on_time
  FROM olist_raw.olist_orders
  WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL
)
SELECT
  COUNT(*)                                 AS total_delivered,
  SUM(is_on_time)                           AS on_time_count,
  COUNT(*) - SUM(is_on_time)               AS late_count,
  ROUND(100.0 * SUM(is_on_time) / COUNT(*), 2) AS on_time_pct,
  ROUND(100.0 * (COUNT(*) - SUM(is_on_time)) / COUNT(*), 2) AS late_pct
FROM delivered;
