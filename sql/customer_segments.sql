-- Customer Segments based on RFM scores

WITH rfm AS (
    SELECT *,
        (recency_score + frequency_score + monetary_score) / 3.0 as rfm_score
    FROM rfm_calculation
)
SELECT
    customer_id,
    email,
    days_active,
    recency_days,
    frequency,
    monetary,
    CASE
        -- Champions (highest value, high engagement)
        WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4
            THEN 'CHAMPIONS'
        -- Loyal Customers (consistent value)
        WHEN frequency_score >= 4 AND monetary_score >= 3
            THEN 'LOYAL'
        -- At Risk (used to spend, haven't in a while)
        WHEN recency_score <= 2 AND frequency_score >= 3
            THEN 'AT_RISK'
        -- Need Attention (bought recently but low frequency)
        WHEN recency_score >= 3 AND frequency_score <= 2
            THEN 'POTENTIAL'
        -- Lost (haven't purchased in ages)
        WHEN recency_score = 1
            THEN 'LOST'
        ELSE 'OTHER'
    END as segment,
    rfm_score
FROM rfm
ORDER BY rfm_score DESC
