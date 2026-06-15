-- Card: Cohort Retention Heatmap
-- Card ID: 50
-- Display: table
-- Dashboard: Customer Analytics Dashboard
-- Description: cohort_month x period retention
-- Database ID: 2
--
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
