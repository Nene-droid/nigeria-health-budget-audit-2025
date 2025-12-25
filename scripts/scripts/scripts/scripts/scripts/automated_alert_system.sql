/*
  PROJECT: Nigeria 2025 Health Budget Audit
  FILE: automated_alert_system.sql
  PURPOSE: Stored Procedure to auto-generate a 'Corruption Risk Report'.
  USAGE: CALL Generate_Corruption_Risk_Report();
*/

DELIMITER //

CREATE PROCEDURE Generate_Corruption_Risk_Report()
BEGIN
    -- 1. Create a temporary staging table for the report
    CREATE TEMPORARY TABLE IF NOT EXISTS Temp_Risk_Report AS
    SELECT 
        b.State,
        SUM(b.Amount_NGN) AS Allocated_Budget,
        COUNT(r.Value) AS Reports_Submitted,
        -- Logic: Flag states based on Budget-to-Reporting Ratio
        CASE 
            WHEN COUNT(r.Value) = 0 THEN 'CRITICAL: GHOST STATE'
            WHEN (SUM(b.Amount_NGN)/NULLIF(COUNT(r.Value),1)) > 50000000 THEN 'HIGH: LOW VISIBILITY'
            ELSE 'MODERATE: MONITOR'
        END AS Risk_Level
    FROM 
        budget_allocations_2025 b
    LEFT JOIN 
        raw_health_indicators r 
        ON b.State = r.State AND r.Year = 2025
    GROUP BY b.State
    HAVING Risk_Level LIKE 'CRITICAL%' OR Risk_Level LIKE 'HIGH%';

    -- 2. Output the High-Risk list for immediate audit action
    SELECT * FROM Temp_Risk_Report
    ORDER BY Allocated_Budget DESC;

    -- 3. Cleanup
    DROP TEMPORARY TABLE IF EXISTS Temp_Risk_Report;
END //

DELIMITER ;
