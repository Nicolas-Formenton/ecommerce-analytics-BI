-- Card: Ops Q7: Review Score Distribution
-- Card ID: 69
-- Display: bar
-- Dashboard: Operations Dashboard
-- Description: None
-- Database ID: 2
--
-- Operations Dashboard Q7: Review Score Distribution
-- Score is 1..5. Source: olist_raw.olist_order_reviews.
-- Joins orders to filter to delivered orders only.
SELECT
  r.review_score,
  COUNT(*)                  AS review_count,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM olist_raw.olist_order_reviews r
JOIN olist_raw.olist_orders o
  ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND r.review_score IS NOT NULL
GROUP BY r.review_score
ORDER BY r.review_score;
