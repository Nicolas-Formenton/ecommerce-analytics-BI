-- Card: Ops Q4: Top 10 Seller States
-- Card ID: 66
-- Display: bar
-- Dashboard: Operations Dashboard
-- Description: None
-- Database ID: 2
--
-- Operations Dashboard Q4: Top 10 Seller States
-- Counts distinct sellers by state. Source: olist_raw.olist_sellers.
SELECT
  seller_state,
  COUNT(*)                 AS seller_count,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM olist_raw.olist_sellers
WHERE seller_state IS NOT NULL
GROUP BY seller_state
ORDER BY seller_count DESC
LIMIT 10;
