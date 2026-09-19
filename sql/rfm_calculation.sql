-- RFM Segmentation: Recency, Frequency, Monetary
-- Base table for customer clustering

WITH customer_activity AS (
    SELECT
        c.customer_id,
        c.email,
        c.signup_date,
        MAX(o.order_date) as last_purchase_date,
        CURRENT_DATE - MAX(o.order_date) as days_since_purchase,
        COUNT(DISTINCT o.order_id) as purchase_frequency,
        SUM(o.order_value) as total_spent,
        AVG(o.order_value) as avg_order_value
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.email, c.signup_date
)
SELECT
    customer_id,
    email,
    CURRENT_DATE - signup_date as days_active,
    COALESCE(days_since_purchase, 999) as recency_days,
    COALESCE(purchase_frequency, 0) as frequency,
    COALESCE(total_spent, 0) as monetary,
    COALESCE(avg_order_value, 0) as avg_order_value,
    -- RFM Scoring (1-5, higher is better)
    NTILE(5) OVER (ORDER BY COALESCE(days_since_purchase, 999) DESC) as recency_score,
    NTILE(5) OVER (ORDER BY COALESCE(purchase_frequency, 0)) as frequency_score,
    NTILE(5) OVER (ORDER BY COALESCE(total_spent, 0)) as monetary_score
FROM customer_activity
