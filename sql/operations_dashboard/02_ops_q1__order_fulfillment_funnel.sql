-- Card: Ops Q1: Order Fulfillment Funnel
-- Card ID: 63
-- Display: bar
-- Dashboard: Operations Dashboard
-- Description: None
-- Database ID: 2
--
-- Operations Dashboard Q1: Order Fulfillment Funnel
-- Counts orders by lifecycle stage, from placement through delivery.
-- Source: olist_raw.olist_orders
SELECT
  order_status,
  COUNT(*) AS order_count
FROM olist_raw.olist_orders
WHERE order_status IN (
  'created',
  'approved',
  'processing',
  'invoiced',
  'shipped',
  'delivered',
  'canceled',
  'unavailable'
)
GROUP BY order_status
ORDER BY
  CASE order_status
    WHEN 'created'     THEN 1
    WHEN 'approved'    THEN 2
    WHEN 'processing'  THEN 3
    WHEN 'invoiced'    THEN 4
    WHEN 'shipped'     THEN 5
    WHEN 'delivered'   THEN 6
    WHEN 'canceled'    THEN 7
    WHEN 'unavailable' THEN 8
  END;
