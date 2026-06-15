-- Card: Repeat Customer Rate
-- Card ID: 52
-- Display: scalar
-- Dashboard: Customer Analytics Dashboard
-- Description: Repeat purchase rate
-- Database ID: 2
--
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
