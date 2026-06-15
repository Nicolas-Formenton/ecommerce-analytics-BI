-- Card: Customer Segments (RFM)
-- Card ID: 48
-- Display: table
-- Dashboard: Customer Analytics Dashboard
-- Description: Percentile-based RFM segmentation
-- Database ID: 2
--
-- customer_01_segments_rfm.sql
-- Customer segmentation using percentile-based RFM (Recency, Frequency, Monetary)
-- Replicates the K-Means RFM from analysis/olist_cx_analytics.py using SQL-only percentile thresholds.
--
-- Thresholds: median (p50) of recency_days, total_orders, total_revenue.
-- Scoring (per spec):
--   R_score = 1 if recency_days  < p50_recency  (recent customers score higher)
--   F_score = 1 if total_orders  > p50_orders   (high frequency scores higher)
--   M_score = 1 if total_revenue > p50_revenue  (high monetary scores higher)
--
-- Segments:
--   Champions         -> R=1, F=1, M=1
--   Loyal High-Value  -> score sum >= 2 AND R=1 (not all-three-good)
--   At-Risk           -> R=0, F=0, M=0
--   Potential Loyalists -> everyone else
--
-- Visualization: pie / bar of customers per segment, with revenue_share and customer_count.

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
    c.total_orders,
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
  COUNT(*)::int                                                       AS customer_count,
  ROUND(SUM(total_revenue)::numeric, 2)                               AS total_revenue,
  ROUND(AVG(total_revenue)::numeric, 2)                               AS avg_revenue_per_customer,
  ROUND(100.0 * COUNT(*)::numeric        / SUM(COUNT(*))        OVER ()::numeric, 2) AS customer_pct,
  ROUND(100.0 * SUM(total_revenue)::numeric / SUM(SUM(total_revenue)) OVER ()::numeric, 2) AS revenue_pct
FROM segmented
GROUP BY segment
ORDER BY total_revenue DESC;
