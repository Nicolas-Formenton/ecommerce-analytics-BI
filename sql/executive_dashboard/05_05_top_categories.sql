-- Card: 05 Top Categories
-- Card ID: 44
-- Display: bar
-- Dashboard: Executive Dashboard
-- Description: None
-- Database ID: 2
--
SELECT
  coalesce(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
  round(sum(oi.price + oi.freight_value)::numeric, 2) AS revenue,
  count(distinct oi.order_id) AS orders
FROM olist_raw.olist_order_items oi
JOIN olist_raw.olist_products p
  ON p.product_id = oi.product_id
LEFT JOIN olist_raw.product_category_name_translation t
  ON t.product_category_name = p.product_category_name
GROUP BY 1
ORDER BY revenue DESC
LIMIT 10;
