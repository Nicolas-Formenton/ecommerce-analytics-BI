-- Card: 03 Avg Ticket
-- Card ID: 42
-- Display: scalar
-- Dashboard: Executive Dashboard
-- Description: None
-- Database ID: 2
--
SELECT
  round(avg(avg_ticket)::numeric, 2) AS avg_ticket
FROM olist_marts.mart_customer_orders
WHERE total_orders > 0;
