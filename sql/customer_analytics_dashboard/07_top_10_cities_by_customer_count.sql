-- Card: Top 10 Cities by Customer Count
-- Card ID: 54
-- Display: bar
-- Dashboard: Customer Analytics Dashboard
-- Description: City-level customers
-- Database ID: 2
--
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
