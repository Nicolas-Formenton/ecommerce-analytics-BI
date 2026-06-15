-- All Metabase SQL queries (sorted by card ID)
-- Total: 70 cards


-- ============================================
-- Card 1: Orders + People
-- Display: table
-- Description: Sample orders joined with products
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 2: Revenue by state
-- Display: map
-- Description: Revenue in the US broken down by state
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 3: Customer satisfaction per category
-- Display: bar
-- Description: Shows the distribution of the product categories along the scale of customer ratings
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 4: Product category orders per age group
-- Display: bar
-- Description: Shows a distribution of orders broken down by product categories across our customers' age groups
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 5: Customer survey responses
-- Display: table
-- Description: Feedback on our products via weekly survey
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 6: Checkout funnel
-- Display: funnel
-- Description: Flow from viewing our website (empty) to checkout and subscribe
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 7: Product breakdown
-- Display: pie
-- Description: Orders for each product, grouped by product category
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 8: Total order amount vs. discount given
-- Display: scatter
-- Description: Analysis of discounts given vs. the size of the order
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 9: Revenue
-- Display: line
-- Description: Canonical metric for revenue across all product lines
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 10: Orders according to sources per quarter
-- Display: pivot
-- Description: Orders placed per quarter broken down by source and formatted to highlight best and worst quarters
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 11: User flow diagram
-- Display: sankey
-- Description: Sankey flow from visiting our website to taking an action
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 12: Revenue and orders over time
-- Display: combo
-- Description: Cumulative revenue overlaid with number of orders placed each month
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 13: Revenue by product category
-- Display: bar
-- Description: Monthly revenue broken down by products
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 14: Subscription seats over time
-- Display: waterfall
-- Description: Number of seats in an average subscription, showing increase and decrease
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 15: Revenue per quarter
-- Display: smartscalar
-- Description: Total revenue last quarter compared to the previous
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 16: Number of subscriptions
-- Display: area
-- Description: Customers that signed up for our monthly subscription
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 17: Revenue goal for this quarter
-- Display: progress
-- Description: Compares total revenue this quarter to our goal
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 18: Product category orders per age
-- Display: bar
-- Description: Shows a distribution of orders broken down by product category across our customers' individual age values
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 19: Number of Orders
-- Display: line
-- Description: Canonical metric for number of orders placed
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 20: Total orders by product category
-- Display: pie
-- Description: Breaks down the overall performance of each of the product categories
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 21: Best selling products
-- Display: row
-- Description: An ordered list of our most successful products
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 22: Average product rating
-- Display: gauge
-- Description: Indicates the average customer review of our products
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 23: Most recent subscription
-- Display: object
-- Description: The most recent subscription in our database
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 24: Orders by product category
-- Display: line
-- Description: Compares the orders of each category quarter over quarter
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 25: All subscriptions in table view
-- Display: table
-- Description: More complete look at all recent subscriptions
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 26: Heavy-Duty Silk Chair trend
-- Display: smartscalar
-- Description: Compares the total number of orders placed for this product this month with the previous period
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 27: Quantity sold per quarter
-- Display: smartscalar
-- Description: Total sum of products sold last quarter compared to the previous
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 28: Revenue per age group
-- Display: bar
-- Description: Shows the revenue distributed by age group
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 29: Enormous Wool Car trend
-- Display: smartscalar
-- Description: Compares the total number of orders placed for this product this month with the previous period
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 30: Unique customers per month
-- Display: smartscalar
-- Description: Unique customer email addresses last quarter compared to the previous
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 31: Checkout funnel - Modified
-- Display: funnel
-- Description: Flow from viewing our website (empty) to checkout and subscribe
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 32: People with age
-- Display: table
-- Description: None
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 33: Revenue per individual age
-- Display: bar
-- Description: Shows a distribution of revenue per individual age values
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 34: Discounts given per quarter
-- Display: smartscalar
-- Description: Total amount of discounts last quarter compared to the previous
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 35: Orders by source per individual age
-- Display: bar
-- Description: Shows a distribution of orders broken down by source across our customers' individual age values
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 36: Orders by source per age group
-- Display: bar
-- Description: Shows a distribution of orders broken down by source across our customers' age groups
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 37: Aerodynamic Copper Knife trend
-- Display: smartscalar
-- Description: Compares the total number of orders placed for this product this month with the previous period
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 38: Order value distribution by category
-- Display: boxplot
-- Description: Order total distribution by category (median, IQR, outliers) to see which categories tend to drive bigger revenue.
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 39: Total orders this quarter
-- Display: scalar
-- Description: Total number of orders in the current quarter.
-- ============================================
-- (No native SQL)

-- ============================================
-- Card 40: 01 Total Revenue
-- Display: scalar
-- Description: None
-- ============================================
SELECT
  round(sum(total_revenue)::numeric, 2) AS total_revenue
FROM olist_marts.mart_monthly_revenue;

-- ============================================
-- Card 41: 02 Total Orders
-- Display: scalar
-- Description: None
-- ============================================
SELECT
  sum(order_count) AS total_orders
FROM olist_marts.mart_monthly_revenue;

-- ============================================
-- Card 42: 03 Avg Ticket
-- Display: scalar
-- Description: None
-- ============================================
SELECT
  round(avg(avg_ticket)::numeric, 2) AS avg_ticket
FROM olist_marts.mart_customer_orders
WHERE total_orders > 0;

-- ============================================
-- Card 43: 04 Revenue Trend
-- Display: line
-- Description: None
-- ============================================
SELECT
  month,
  total_revenue,
  order_count
FROM olist_marts.mart_monthly_revenue
ORDER BY month;

-- ============================================
-- Card 44: 05 Top Categories
-- Display: bar
-- Description: None
-- ============================================
SELECT
  coalesce(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
  round(sum(oi.price + oi.freight_value)::numeric, 2) AS revenue,
  count(distinct oi.order_id) AS orders
FROM olist_raw.olist_order_items oi
JOIN olist_raw.olist_products p
  ON p.product_id = oi.product_id
LEFT JOIN olist_raw.product_category_name_translation t
  ON t.product_category_name = p.product_category_name
GROUP BY 1
ORDER BY revenue DESC
LIMIT 10;

-- ============================================
-- Card 45: 06 Revenue by State
-- Display: bar
-- Description: None
-- ============================================
SELECT
  customer_state AS state,
  round(sum(total_revenue)::numeric, 2) AS revenue,
  sum(total_orders) AS orders,
  count(distinct customer_unique_id) AS customers
FROM olist_marts.mart_customer_orders
WHERE customer_state IS NOT NULL
GROUP BY 1
ORDER BY revenue DESC;

-- ============================================
-- Card 46: 07 Payment Distribution
-- Display: pie
-- Description: None
-- ============================================
SELECT
  payment_type AS payment_method,
  round(sum(payment_value)::numeric, 2) AS total_value,
  count(*) AS payment_count
FROM olist_raw.olist_order_payments
WHERE payment_type IS NOT NULL
GROUP BY 1
ORDER BY total_value DESC;

-- ============================================
-- Card 47: 08 Order Status
-- Display: pie
-- Description: None
-- ============================================
SELECT
  order_status,
  count(*) AS order_count,
  round(100.0 * count(*) / sum(count(*)) OVER (), 2) AS pct
FROM olist_raw.olist_orders
WHERE order_status IS NOT NULL
GROUP BY 1
ORDER BY order_count DESC;

-- ============================================
-- Card 48: Customer Segments (RFM)
-- Display: table
-- Description: Percentile-based RFM segmentation
-- ============================================
-- customer_01_segments_rfm.sql
-- Customer segmentation using percentile-based RFM (Recency, Frequency, Monetary)
-- Replicates the K-Means RFM from analysis/olist_cx_analytics.py using SQL-only percentile thresholds.
--
-- Thresholds: median (p50) of recency_days, total_orders, total_revenue.
-- Scoring (per spec):
--   R_score = 1 if recency_days  < p50_recency  (recent customers score higher)
--   F_score = 1 if total_orders  > p50_orders   (high frequency scores higher)
--   M_score = 1 if total_revenue > p50_revenue  (high monetary scores higher)
--
-- Segments:
--   Champions         -> R=1, F=1, M=1
--   Loyal High-Value  -> score sum >= 2 AND R=1 (not all-three-good)
--   At-Risk           -> R=0, F=0, M=0
--   Potential Loyalists -> everyone else
--
-- Visualization: pie / bar of customers per segment, with revenue_share and customer_count.

WITH thresholds AS (
  SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY recency_days)   AS p50_recency,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_orders)   AS p50_orders,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_revenue)  AS p50_revenue
  FROM olist_marts.mart_customer_orders
),
scored AS (
  SELECT
    c.customer_unique_id,
    c.total_revenue,
    c.total_orders,
    CASE WHEN c.recency_days  < t.p50_recency THEN 1 ELSE 0 END AS r_score,
    CASE WHEN c.total_orders  > t.p50_orders  THEN 1 ELSE 0 END AS f_score,
    CASE WHEN c.total_revenue > t.p50_revenue THEN 1 ELSE 0 END AS m_score
  FROM olist_marts.mart_customer_orders c
  CROSS JOIN thresholds t
),
segmented AS (
  SELECT
    s.*,
    CASE
      WHEN r_score = 1 AND f_score = 1 AND m_score = 1               THEN 'Champions'
      WHEN (r_score + f_score + m_score) >= 2 AND r_score = 1         THEN 'Loyal High-Value'
      WHEN r_score = 0 AND f_score = 0 AND m_score = 0               THEN 'At-Risk'
      ELSE 'Potential Loyalists'
    END AS segment
  FROM scored s
)
SELECT
  segment,
  COUNT(*)::int                                                       AS customer_count,
  ROUND(SUM(total_revenue)::numeric, 2)                               AS total_revenue,
  ROUND(AVG(total_revenue)::numeric, 2)                               AS avg_revenue_per_customer,
  ROUND(100.0 * COUNT(*)::numeric        / SUM(COUNT(*))        OVER ()::numeric, 2) AS customer_pct,
  ROUND(100.0 * SUM(total_revenue)::numeric / SUM(SUM(total_revenue)) OVER ()::numeric, 2) AS revenue_pct
FROM segmented
GROUP BY segment
ORDER BY total_revenue DESC;

-- ============================================
-- Card 49: Revenue by Segment
-- Display: bar
-- Description: Bar chart of revenue per segment
-- ============================================
-- customer_02_revenue_by_segment.sql
-- Same segmentation logic as customer_01_segments_rfm.sql, but pivoted to
-- produce a clean 2-column result (segment, total_revenue) optimized for a
-- horizontal bar chart in Metabase.

WITH thresholds AS (
  SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY recency_days)   AS p50_recency,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_orders)   AS p50_orders,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_revenue)  AS p50_revenue
  FROM olist_marts.mart_customer_orders
),
scored AS (
  SELECT
    c.customer_unique_id,
    c.total_revenue,
    CASE WHEN c.recency_days  < t.p50_recency THEN 1 ELSE 0 END AS r_score,
    CASE WHEN c.total_orders  > t.p50_orders  THEN 1 ELSE 0 END AS f_score,
    CASE WHEN c.total_revenue > t.p50_revenue THEN 1 ELSE 0 END AS m_score
  FROM olist_marts.mart_customer_orders c
  CROSS JOIN thresholds t
),
segmented AS (
  SELECT
    s.*,
    CASE
      WHEN r_score = 1 AND f_score = 1 AND m_score = 1               THEN 'Champions'
      WHEN (r_score + f_score + m_score) >= 2 AND r_score = 1         THEN 'Loyal High-Value'
      WHEN r_score = 0 AND f_score = 0 AND m_score = 0               THEN 'At-Risk'
      ELSE 'Potential Loyalists'
    END AS segment
  FROM scored s
)
SELECT
  segment,
  ROUND(SUM(total_revenue)::numeric, 2) AS total_revenue
FROM segmented
GROUP BY segment
ORDER BY total_revenue DESC;

-- ============================================
-- Card 50: Cohort Retention Heatmap
-- Display: table
-- Description: cohort_month x period retention
-- ============================================
-- customer_03_cohort_retention.sql
-- Cohort retention heatmap: rows = cohort_month (customer's first order month),
-- columns = period_offset (0, 1, 2, ... months since first order),
-- cells = % of cohort customers who placed at least one order in that period.
--
-- Source: olist_raw.olist_orders joined to mart_customer_orders to get
-- customer_unique_id (each row in mart is one unique human, not one order).

WITH cohort_base AS (
  SELECT
    c.customer_unique_id,
    DATE_TRUNC('month', MIN(o.order_purchase_timestamp))::date AS cohort_month
  FROM olist_raw.olist_orders o
  JOIN olist_marts.mart_customer_orders c
    ON c.customer_id = o.customer_id
  WHERE o.order_status IN ('delivered', 'shipped', 'invoiced', 'approved', ('created')::varchar)
    AND o.order_purchase_timestamp IS NOT NULL
  GROUP BY c.customer_unique_id
),
activity AS (
  SELECT
    c.customer_unique_id,
    DATE_TRUNC('month', o.order_purchase_timestamp)::date AS activity_month
  FROM olist_raw.olist_orders o
  JOIN olist_marts.mart_customer_orders c
    ON c.customer_id = o.customer_id
  WHERE o.order_purchase_timestamp IS NOT NULL
  GROUP BY c.customer_unique_id, DATE_TRUNC('month', o.order_purchase_timestamp)
),
cohort_activity AS (
  SELECT
    a.customer_unique_id,
    b.cohort_month,
    a.activity_month,
    (EXTRACT(YEAR  FROM a.activity_month) - EXTRACT(YEAR  FROM b.cohort_month)) * 12
      + (EXTRACT(MONTH FROM a.activity_month) - EXTRACT(MONTH FROM b.cohort_month)) AS period_offset
  FROM activity a
  JOIN cohort_base b ON a.customer_unique_id = b.customer_unique_id
),
cohort_sizes AS (
  SELECT cohort_month, COUNT(*)::numeric AS cohort_size
  FROM cohort_base
  GROUP BY cohort_month
),
retention AS (
  SELECT
    ca.cohort_month,
    ca.period_offset,
    COUNT(DISTINCT ca.customer_unique_id)::numeric AS active_customers
  FROM cohort_activity ca
  GROUP BY ca.cohort_month, ca.period_offset
)
SELECT
  TO_CHAR(r.cohort_month, 'YYYY-MM')                       AS cohort_month,
  r.period_offset                                          AS period,
  ROUND(100.0 * r.active_customers / s.cohort_size, 2)     AS retention_pct,
  r.active_customers::int                                  AS active_customers,
  s.cohort_size::int                                       AS cohort_size
FROM retention r
JOIN cohort_sizes s ON s.cohort_month = r.cohort_month
WHERE r.period_offset BETWEEN 0 AND 12
ORDER BY r.cohort_month, r.period_offset;

-- ============================================
-- Card 51: CLV Distribution
-- Display: bar
-- Description: Histogram of total_revenue
-- ============================================
-- customer_04_clv_distribution.sql
-- Customer Lifetime Value (CLV) distribution: histogram of total_revenue per
-- customer. Bins are fixed-width (50 BRL) up to 1000 BRL, then coarser tail
-- bins. Returns 2 columns: clv_bin (text label), customer_count.

WITH bucketed AS (
  SELECT
    CASE
      WHEN total_revenue = 0                   THEN '0 (no orders)'
      WHEN total_revenue <   50                THEN '0-50'
      WHEN total_revenue <  100                THEN '50-100'
      WHEN total_revenue <  200                THEN '100-200'
      WHEN total_revenue <  300                THEN '200-300'
      WHEN total_revenue <  500                THEN '300-500'
      WHEN total_revenue <  750                THEN '500-750'
      WHEN total_revenue < 1000                THEN '750-1000'
      WHEN total_revenue < 2000                THEN '1000-2000'
      WHEN total_revenue < 5000                THEN '2000-5000'
      ELSE '5000+'
    END AS clv_bin,
    CASE
      WHEN total_revenue = 0                   THEN 0
      WHEN total_revenue <   50                THEN 1
      WHEN total_revenue <  100                THEN 2
      WHEN total_revenue <  200                THEN 3
      WHEN total_revenue <  300                THEN 4
      WHEN total_revenue <  500                THEN 5
      WHEN total_revenue <  750                THEN 6
      WHEN total_revenue < 1000                THEN 7
      WHEN total_revenue < 2000                THEN 8
      WHEN total_revenue < 5000                THEN 9
      ELSE 10
    END AS bin_order
  FROM olist_marts.mart_customer_orders
)
SELECT
  clv_bin,
  COUNT(*)::int AS customer_count
FROM bucketed
GROUP BY clv_bin, bin_order
ORDER BY bin_order;

-- ============================================
-- Card 52: Repeat Customer Rate
-- Display: scalar
-- Description: Repeat purchase rate
-- ============================================
-- customer_05_repeat_customer_rate.sql
-- Repeat customer rate: % of unique customers with more than 1 order.
-- Groups by customer_unique_id (the de-duplicated human), counting distinct
-- customer_id per unique_id to get true order count per person.
-- Original analysis reported ~3% repeat rate; this query should reproduce it.

WITH per_unique AS (
  SELECT
    customer_unique_id,
    COUNT(DISTINCT customer_id) AS orders_count
  FROM olist_marts.mart_customer_orders
  GROUP BY customer_unique_id
)
SELECT
  COUNT(*)::int                                                                AS total_customers,
  COUNT(*) FILTER (WHERE orders_count >= 1)::int                               AS customers_with_orders,
  COUNT(*) FILTER (WHERE orders_count >= 2)::int                               AS repeat_customers,
  COUNT(*) FILTER (WHERE orders_count >= 3)::int                               AS three_plus_orders,
  COUNT(*) FILTER (WHERE orders_count >= 5)::int                               AS five_plus_orders,
  ROUND(100.0 * COUNT(*) FILTER (WHERE orders_count >= 2) / COUNT(*), 2)      AS repeat_rate_pct,
  ROUND(100.0 * COUNT(*) FILTER (WHERE orders_count >= 3) / COUNT(*), 2)      AS three_plus_rate_pct,
  ROUND(100.0 * COUNT(*) FILTER (WHERE orders_count >= 5) / COUNT(*), 2)      AS five_plus_rate_pct
FROM per_unique;

-- ============================================
-- Card 53: Avg Review Score by Category
-- Display: bar
-- Description: Reviews per product category
-- ============================================
-- customer_06_review_by_category.sql
-- Average review score per product category, joined through
-- order_items -> products -> translations -> reviews. Uses the translation
-- table to convert Portuguese category names to English. Returns only
-- categories with >= 100 reviews to avoid noise from single-review rows.

SELECT
  COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
                                                                       AS category,
  COUNT(r.review_id)::int                                              AS review_count,
  ROUND(AVG(r.review_score)::numeric, 2)                               AS avg_review_score,
  ROUND(100.0 * COUNT(*) FILTER (WHERE r.review_score >= 4) / COUNT(*), 2) AS pct_4_or_5
FROM olist_raw.olist_order_items i
JOIN olist_raw.olist_products p
  ON p.product_id = i.product_id
LEFT JOIN olist_raw.product_category_name_translation t
  ON t.product_category_name = p.product_category_name
JOIN olist_raw.olist_order_reviews r
  ON r.order_id = i.order_id
WHERE r.review_score IS NOT NULL
GROUP BY 1
HAVING COUNT(r.review_id) >= 100
ORDER BY avg_review_score DESC, review_count DESC;

-- ============================================
-- Card 54: Top 10 Cities by Customer Count
-- Display: bar
-- Description: City-level customers
-- ============================================
-- customer_07_top_cities.sql
-- Top 10 cities by customer count, with revenue contribution. Uses
-- customer_city / customer_state from mart_customer_orders and groups by
-- (city, state) to disambiguate cities with identical names across states.

SELECT
  customer_city,
  customer_state,
  COUNT(*)::int                                       AS customer_count,
  ROUND(SUM(total_revenue)::numeric, 2)               AS total_revenue,
  ROUND(AVG(total_revenue)::numeric, 2)               AS avg_revenue_per_customer
FROM olist_marts.mart_customer_orders
WHERE customer_city IS NOT NULL
GROUP BY customer_city, customer_state
ORDER BY customer_count DESC
LIMIT 10;

-- ============================================
-- Card 55: Ops Q1: Order Fulfillment Funnel
-- Display: bar
-- Description: None
-- ============================================
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

-- ============================================
-- Card 56: Ops Q2: Avg Delivery Time by Customer State
-- Display: bar
-- Description: None
-- ============================================
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

-- ============================================
-- Card 57: Ops Q3: Delivery Delay Distribution
-- Display: bar
-- Description: None
-- ============================================
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

-- ============================================
-- Card 58: Ops Q4: Top 10 Seller States
-- Display: bar
-- Description: None
-- ============================================
-- Operations Dashboard Q4: Top 10 Seller States
-- Counts distinct sellers by state. Source: olist_raw.olist_sellers.
SELECT
  seller_state,
  COUNT(*)                 AS seller_count,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM olist_raw.olist_sellers
WHERE seller_state IS NOT NULL
GROUP BY seller_state
ORDER BY seller_count DESC
LIMIT 10;

-- ============================================
-- Card 59: Ops Q5: On-Time Delivery Rate
-- Display: table
-- Description: None
-- ============================================
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

-- ============================================
-- Card 60: Ops Q6: Order Volume by Day of Week
-- Display: bar
-- Description: None
-- ============================================
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

-- ============================================
-- Card 61: Ops Q7: Review Score Distribution
-- Display: bar
-- Description: None
-- ============================================
-- Operations Dashboard Q7: Review Score Distribution
-- Score is 1..5. Source: olist_raw.olist_order_reviews.
-- Joins orders to filter to delivered orders only.
SELECT
  r.review_score,
  COUNT(*)                  AS review_count,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM olist_raw.olist_order_reviews r
JOIN olist_raw.olist_orders o
  ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND r.review_score IS NOT NULL
GROUP BY r.review_score
ORDER BY r.review_score;

-- ============================================
-- Card 62: Ops Q1: Order Fulfillment Funnel
-- Display: bar
-- Description: None
-- ============================================
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

-- ============================================
-- Card 63: Ops Q1: Order Fulfillment Funnel
-- Display: bar
-- Description: None
-- ============================================
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

-- ============================================
-- Card 64: Ops Q2: Avg Delivery Time by Customer State
-- Display: bar
-- Description: None
-- ============================================
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

-- ============================================
-- Card 65: Ops Q3: Delivery Delay Distribution
-- Display: bar
-- Description: None
-- ============================================
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

-- ============================================
-- Card 66: Ops Q4: Top 10 Seller States
-- Display: bar
-- Description: None
-- ============================================
-- Operations Dashboard Q4: Top 10 Seller States
-- Counts distinct sellers by state. Source: olist_raw.olist_sellers.
SELECT
  seller_state,
  COUNT(*)                 AS seller_count,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM olist_raw.olist_sellers
WHERE seller_state IS NOT NULL
GROUP BY seller_state
ORDER BY seller_count DESC
LIMIT 10;

-- ============================================
-- Card 67: Ops Q5: On-Time Delivery Rate
-- Display: table
-- Description: None
-- ============================================
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

-- ============================================
-- Card 68: Ops Q6: Order Volume by Day of Week
-- Display: bar
-- Description: None
-- ============================================
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

-- ============================================
-- Card 69: Ops Q7: Review Score Distribution
-- Display: bar
-- Description: None
-- ============================================
-- Operations Dashboard Q7: Review Score Distribution
-- Score is 1..5. Source: olist_raw.olist_order_reviews.
-- Joins orders to filter to delivered orders only.
SELECT
  r.review_score,
  COUNT(*)                  AS review_count,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM olist_raw.olist_order_reviews r
JOIN olist_raw.olist_orders o
  ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND r.review_score IS NOT NULL
GROUP BY r.review_score
ORDER BY r.review_score;

-- ============================================
-- Card 70: Ops Dashboard Description
-- Display: text
-- Description: None
-- ============================================
SELECT 1
