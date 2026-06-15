-- Card: Revenue by Segment
-- Card ID: 49
-- Display: bar
-- Dashboard: Customer Analytics Dashboard
-- Description: Bar chart of revenue per segment
-- Database ID: 2
--
-- customer_02_revenue_by_segment.sql
-- Same segmentation logic as customer_01_segments_rfm.sql, but pivoted to
-- produce a clean 2-column result (segment, total_revenue) optimized for a
-- horizontal bar chart in Metabase.

WITH thresholds AS (
  SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY recency_days)   AS p50_recency,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_orders)   AS p50_orders,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_revenue)  AS p50_revenue
  FROM olist_marts.mart_customer_orders
),
scored AS (
  SELECT
    c.customer_unique_id,
    c.total_revenue,
    CASE WHEN c.recency_days  < t.p50_recency THEN 1 ELSE 0 END AS r_score,
    CASE WHEN c.total_orders  > t.p50_orders  THEN 1 ELSE 0 END AS f_score,
    CASE WHEN c.total_revenue > t.p50_revenue THEN 1 ELSE 0 END AS m_score
  FROM olist_marts.mart_customer_orders c
  CROSS JOIN thresholds t
),
segmented AS (
  SELECT
    s.*,
    CASE
      WHEN r_score = 1 AND f_score = 1 AND m_score = 1               THEN 'Champions'
      WHEN (r_score + f_score + m_score) >= 2 AND r_score = 1         THEN 'Loyal High-Value'
      WHEN r_score = 0 AND f_score = 0 AND m_score = 0               THEN 'At-Risk'
      ELSE 'Potential Loyalists'
    END AS segment
  FROM scored s
)
SELECT
  segment,
  ROUND(SUM(total_revenue)::numeric, 2) AS total_revenue
FROM segmented
GROUP BY segment
ORDER BY total_revenue DESC;
