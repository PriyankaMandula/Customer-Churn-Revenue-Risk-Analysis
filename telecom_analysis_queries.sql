
SELECT *
FROM telecom_churns.cleaned_telecom_churn
LIMIT 5;
-- --------------------TOTAL CUSTOMERS COUNT-------------------
SELECT COUNT(*) AS total_customers
FROM cleaned_telecom_churn;

-- -----------------------OVERALL CHURN RATE-------------------------------
SELECT 
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate
FROM cleaned_telecom_churn;

-- -------------------------------CHURN BY TENURE BUCKET-----------------------
SELECT 
    TenureBucket,
    COUNT(*) AS customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn='yes' THEN 1 ELSE 0 END)/COUNT(*),
        2
    ) AS churn_rate
FROM cleaned_telecom_churn
GROUP BY TenureBucket
ORDER BY TenureBucket;

-- --------------------------------CHURN BY INTERNET SERVICES-------------------
SELECT 
    InternetService,
    COUNT(*) AS customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn='yes' THEN 1 ELSE 0 END)/COUNT(*),
        2
    ) AS churn_rate
FROM cleaned_telecom_churn
WHERE InternetService != 'unknown'
GROUP BY InternetService
ORDER BY churn_rate DESC;

-- -------------------------------CHURN BY CONTRACT TYPE---------------
SELECT 
    Contract,
    COUNT(*) AS customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn='yes' THEN 1 ELSE 0 END)/COUNT(*),
        2
    ) AS churn_rate
FROM cleaned_telecom_churn
GROUP BY Contract
ORDER BY churn_rate DESC;

-- ----------------------------CHURN BY PAYMENT METHOD--------------
SELECT 
    PaymentMethod,
    COUNT(*) AS customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn='yes' THEN 1 ELSE 0 END)/COUNT(*),
        2
    ) AS churn_rate
FROM cleaned_telecom_churn
WHERE PaymentMethod != 'unknown'
GROUP BY PaymentMethod
ORDER BY churn_rate DESC;

-- ------------------------------REVENUE RISK --------------------
SELECT 
    ROUND(SUM(MonthlyCharges),2) AS monthly_revenue_lost,
    ROUND(SUM(MonthlyCharges)*12,2) AS annual_revenue_risk
FROM cleaned_telecom_churn
WHERE Churn='yes';

-- -----------------------------------High-Risk Segment Ranking (Advanced)----------------------
SELECT 
    TenureBucket,
    InternetService,
    Contract,
    COUNT(*) AS customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn='yes' THEN 1 ELSE 0 END)/COUNT(*),
        2
    ) AS churn_rate
FROM cleaned_telecom_churn
WHERE InternetService != 'unknown'
GROUP BY TenureBucket, InternetService, Contract
HAVING COUNT(*) > 20
ORDER BY churn_rate DESC;