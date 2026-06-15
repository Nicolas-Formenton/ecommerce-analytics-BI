-- Card: CLV Distribution
-- Card ID: 51
-- Display: bar
-- Dashboard: Customer Analytics Dashboard
-- Description: Histogram of total_revenue
-- Database ID: 2
--
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
