-- Card: 06 Revenue by State
-- Card ID: 45
-- Display: bar
-- Dashboard: Executive Dashboard
-- Description: None
-- Database ID: 2
--
SELECT
  customer_state AS state,
  round(sum(total_revenue)::numeric, 2) AS revenue,
  sum(total_orders) AS orders,
  count(distinct customer_unique_id) AS customers
FROM olist_marts.mart_customer_orders
WHERE customer_state IS NOT NULL
GROUP BY 1
ORDER BY revenue DESC;
