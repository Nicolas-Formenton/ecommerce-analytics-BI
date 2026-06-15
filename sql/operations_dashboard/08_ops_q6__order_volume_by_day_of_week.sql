-- Card: Ops Q6: Order Volume by Day of Week
-- Card ID: 68
-- Display: bar
-- Dashboard: Operations Dashboard
-- Description: None
-- Database ID: 2
--
-- Operations Dashboard Q6: Order Volume by Day of Week
-- Extracts day-of-week from order_purchase_timestamp (0=Sunday ... 6=Saturday).
-- Source: olist_raw.olist_orders
SELECT
  EXTRACT(dow FROM order_purchase_timestamp)::int AS dow_index,
  CASE EXTRACT(dow FROM order_purchase_timestamp)::int
    WHEN 0 THEN 'Sunday'
    WHEN 1 THEN 'Monday'
    WHEN 2 THEN 'Tuesday'
    WHEN 3 THEN 'Wednesday'
    WHEN 4 THEN 'Thursday'
    WHEN 5 THEN 'Friday'
    WHEN 6 THEN 'Saturday'
  END                       AS day_name,
  COUNT(*)                  AS order_count
FROM olist_raw.olist_orders
WHERE order_purchase_timestamp IS NOT NULL
GROUP BY 1, 2
ORDER BY dow_index;
