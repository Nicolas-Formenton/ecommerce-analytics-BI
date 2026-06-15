-- Card: 02 Total Orders
-- Card ID: 41
-- Display: scalar
-- Dashboard: Executive Dashboard
-- Description: None
-- Database ID: 2
--
SELECT
  sum(order_count) AS total_orders
FROM olist_marts.mart_monthly_revenue;
