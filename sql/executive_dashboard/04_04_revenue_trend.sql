-- Card: 04 Revenue Trend
-- Card ID: 43
-- Display: line
-- Dashboard: Executive Dashboard
-- Description: None
-- Database ID: 2
--
SELECT
  month,
  total_revenue,
  order_count
FROM olist_marts.mart_monthly_revenue
ORDER BY month;
