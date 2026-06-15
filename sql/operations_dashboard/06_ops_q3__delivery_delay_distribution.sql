-- Card: Ops Q3: Delivery Delay Distribution
-- Card ID: 65
-- Display: bar
-- Dashboard: Operations Dashboard
-- Description: None
-- Database ID: 2
--
-- Operations Dashboard Q3: Delivery Delay Distribution (Histogram Buckets)
-- For delivered orders, delay = delivered - estimated.
-- Negative = early, 0 = on time, positive = late.
-- Source: olist_raw.olist_orders
WITH delivered_with_delay AS (
  SELECT
    (order_delivered_customer_date - order_estimated_delivery_date) AS delay_interval
  FROM olist_raw.olist_orders
  WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL
),
bucketed AS (
  SELECT
    CASE
      WHEN delay_interval <= INTERVAL '-30 days' THEN '<= -30 days (very early)'
      WHEN delay_interval <= INTERVAL '-15 days' THEN '-30 to -15 days'
      WHEN delay_interval <= INTERVAL  '-7 days' THEN '-15 to -7 days'
      WHEN delay_interval <  INTERVAL   '0 days' THEN '-7 to -1 days'
      WHEN delay_interval  = INTERVAL   '0 days' THEN '0 days (on time)'
      WHEN delay_interval <= INTERVAL   '3 days' THEN '1 to 3 days late'
      WHEN delay_interval <= INTERVAL   '7 days' THEN '4 to 7 days late'
      WHEN delay_interval <= INTERVAL  '15 days' THEN '8 to 15 days late'
      WHEN delay_interval <= INTERVAL  '30 days' THEN '16 to 30 days late'
      ELSE '> 30 days late'
    END AS delay_bucket,
    CASE
      WHEN delay_interval <= INTERVAL '-30 days' THEN 1
      WHEN delay_interval <= INTERVAL '-15 days' THEN 2
      WHEN delay_interval <= INTERVAL  '-7 days' THEN 3
      WHEN delay_interval <  INTERVAL   '0 days' THEN 4
      WHEN delay_interval  = INTERVAL   '0 days' THEN 5
      WHEN delay_interval <= INTERVAL   '3 days' THEN 6
      WHEN delay_interval <= INTERVAL   '7 days' THEN 7
      WHEN delay_interval <= INTERVAL  '15 days' THEN 8
      WHEN delay_interval <= INTERVAL  '30 days' THEN 9
      ELSE 10
    END AS bucket_order
  FROM delivered_with_delay
)
SELECT
  delay_bucket,
  COUNT(*) AS order_count
FROM bucketed
GROUP BY delay_bucket, bucket_order
ORDER BY bucket_order;
