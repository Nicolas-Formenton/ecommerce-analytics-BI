-- Card: Ops Q2: Avg Delivery Time by Customer State
-- Card ID: 64
-- Display: bar
-- Dashboard: Operations Dashboard
-- Description: None
-- Database ID: 2
--
-- Operations Dashboard Q2: Average Delivery Time by Customer State
-- Filters to delivered orders, computes delivery days = delivered - purchase.
-- Joins olist_orders to olist_customers for state.
-- Source: olist_raw.olist_orders, olist_raw.olist_customers
SELECT
  c.customer_state,
  COUNT(*)                                AS delivered_orders,
  ROUND(AVG(
    EXTRACT(epoch FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400.0
  )::numeric, 2)                          AS avg_delivery_days,
  MIN(
    EXTRACT(epoch FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400.0
  )::numeric(10,2)                        AS min_delivery_days,
  MAX(
    EXTRACT(epoch FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400.0
  )::numeric(10,2)                        AS max_delivery_days
FROM olist_raw.olist_orders o
JOIN olist_raw.olist_customers c
  ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_purchase_timestamp IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_days DESC;
