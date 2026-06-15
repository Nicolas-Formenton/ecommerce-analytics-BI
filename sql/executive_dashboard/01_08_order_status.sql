-- Card: 08 Order Status
-- Card ID: 47
-- Display: pie
-- Dashboard: Executive Dashboard
-- Description: None
-- Database ID: 2
--
SELECT
  order_status,
  count(*) AS order_count,
  round(100.0 * count(*) / sum(count(*)) OVER (), 2) AS pct
FROM olist_raw.olist_orders
WHERE order_status IS NOT NULL
GROUP BY 1
ORDER BY order_count DESC;
