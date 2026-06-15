-- Card: 01 Total Revenue
-- Card ID: 40
-- Display: scalar
-- Dashboard: Executive Dashboard
-- Description: None
-- Database ID: 2
--
SELECT
  round(sum(total_revenue)::numeric, 2) AS total_revenue
FROM olist_marts.mart_monthly_revenue;
