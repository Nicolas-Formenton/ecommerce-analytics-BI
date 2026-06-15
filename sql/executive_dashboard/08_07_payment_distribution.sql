-- Card: 07 Payment Distribution
-- Card ID: 46
-- Display: pie
-- Dashboard: Executive Dashboard
-- Description: None
-- Database ID: 2
--
SELECT
  payment_type AS payment_method,
  round(sum(payment_value)::numeric, 2) AS total_value,
  count(*) AS payment_count
FROM olist_raw.olist_order_payments
WHERE payment_type IS NOT NULL
GROUP BY 1
ORDER BY total_value DESC;
