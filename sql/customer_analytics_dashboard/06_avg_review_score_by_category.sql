-- Card: Avg Review Score by Category
-- Card ID: 53
-- Display: bar
-- Dashboard: Customer Analytics Dashboard
-- Description: Reviews per product category
-- Database ID: 2
--
-- customer_06_review_by_category.sql
-- Average review score per product category, joined through
-- order_items -> products -> translations -> reviews. Uses the translation
-- table to convert Portuguese category names to English. Returns only
-- categories with >= 100 reviews to avoid noise from single-review rows.

SELECT
  COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
                                                                       AS category,
  COUNT(r.review_id)::int                                              AS review_count,
  ROUND(AVG(r.review_score)::numeric, 2)                               AS avg_review_score,
  ROUND(100.0 * COUNT(*) FILTER (WHERE r.review_score >= 4) / COUNT(*), 2) AS pct_4_or_5
FROM olist_raw.olist_order_items i
JOIN olist_raw.olist_products p
  ON p.product_id = i.product_id
LEFT JOIN olist_raw.product_category_name_translation t
  ON t.product_category_name = p.product_category_name
JOIN olist_raw.olist_order_reviews r
  ON r.order_id = i.order_id
WHERE r.review_score IS NOT NULL
GROUP BY 1
HAVING COUNT(r.review_id) >= 100
ORDER BY avg_review_score DESC, review_count DESC;
