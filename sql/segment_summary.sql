-- Segment Summary Statistics
-- High-level overview of each segment

WITH segments AS (
    SELECT * FROM customer_segments
)
SELECT
    segment,
    COUNT(*) as customer_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) as pct_of_total,
    ROUND(AVG(monetary), 2) as avg_ltv,
    ROUND(AVG(frequency), 1) as avg_purchases,
    ROUND(AVG(days_active), 0) as avg_days_active,
    MIN(monetary) as min_ltv,
    MAX(monetary) as max_ltv,
    COUNT(CASE WHEN recency_days > 180 THEN 1 END) as inactive_6m_plus
FROM segments
GROUP BY segment
ORDER BY avg_ltv DESC
