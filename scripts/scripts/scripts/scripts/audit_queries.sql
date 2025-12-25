/*
  PROJECT: Nigeria 2025 Health Budget Audit
  FILE: audit_queries.sql
  PURPOSE: Master Audit Logic - Detects Data Deserts, Ghost States, and Fiscal Anomalies.
  AUDITOR: AmakaData
*/

-- =============================================
-- 1. THE "DATA DESERT" CHECK
-- Identifies states that are missing critical maternal health data.
-- Risk: You cannot manage what you do not measure.
-- =============================================
SELECT Indicator_Name, Year, State, Value
FROM raw_health_indicators
WHERE Indicator_Name LIKE '%Maternal%' AND Value IS NULL;

-- =============================================
-- 2. THE "GHOST STATE" DETECTOR
-- Finds states present in the Master List but have submitted ZERO records.
-- Risk: Total lack of accountability.
-- =============================================
SELECT s.State_Name as Ghost_State
FROM nigeria_states_master s
LEFT JOIN raw_health_indicators r 
    ON s.State_Name = r.State AND r.Year = 2025
WHERE r.Record_ID IS NULL;

-- =============================================
-- 3. STATISTICAL OUTLIER DETECTION (Z-Score)
-- Uses statistical deviation to find "fake" or "impossible" numbers.
-- Logic: If a value is > 2 Standard Deviations from the mean, flag it.
-- =============================================
WITH Stats AS (
    SELECT Indicator_Name, AVG(Value) AS Avg_Val, STDDEV(Value) AS Std_Dev
    FROM raw_health_indicators
    GROUP BY Indicator_Name
)
SELECT r.Year, r.State, r.Indicator_Name, r.Value,
       (r.Value - s.Avg_Val)/s.Std_Dev AS Z_Score
FROM raw_health_indicators r
JOIN Stats s ON r.Indicator_Name = s.Indicator_Name
WHERE ABS((r.Value - s.Avg_Val)/s.Std_Dev) > 2;

-- =============================================
-- 4. THE "FISCAL BLACK HOLE" (Forensic Ratio)
-- Calculates the "Cost Per Reported Outcome".
-- Risk: High Budget + Low Reporting = High probability of misappropriation.
-- =============================================
SELECT 
    b.State, 
    SUM(b.Amount_NGN) AS Total_Budget_Allocated,
    COUNT(r.Value) AS Reports_Submitted,
    (SUM(b.Amount_NGN) / NULLIF(COUNT(r.Value), 0)) AS Cost_Per_Report_NGN
FROM budget_allocations_2025 b
LEFT JOIN raw_health_indicators r 
    ON b.State = r.State AND r.Year = 2025
GROUP BY b.State
HAVING SUM(b.Amount_NGN) > 1000000000 -- Filter for Billions Only
ORDER BY Reports_Submitted ASC;
