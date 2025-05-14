CREATE OR REPLACE VIEW fraud_enriched AS
WITH stats AS (
    SELECT 
        AVG(amount) AS avg_amount,
        STDDEV(amount) AS stddev_amount
    FROM creditcard_data
    WHERE "Class" = 1
)
SELECT 
    c.*,
    FLOOR(c.time / 3600)::int AS transaction_hour,
    CASE 
        WHEN c.amount > s.avg_amount + 2 * s.stddev_amount THEN 'Outlier'
        ELSE 'Normal'
    END AS is_outlier,
    CASE 
        WHEN c.amount > 1000 THEN 'High'
        WHEN c.amount BETWEEN 500 AND 1000 THEN 'Medium'
        ELSE 'Low'
    END AS fraud_risk_level
FROM creditcard_data c
CROSS JOIN stats s;