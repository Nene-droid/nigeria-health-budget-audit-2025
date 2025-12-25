/*
  PROJECT: Nigeria 2025 Health Budget Audit
  FILE: import_data.sql
  PURPOSE: ETL Script to load raw CSV datasets into the database.
  INSTRUCTIONS: Run this after schema_setup.sql
*/

-- =============================================
-- 1. LOAD HEALTH INDICATORS
-- Imports the raw mortality data from the data/ folder.
-- =============================================
LOAD DATA INFILE '../data/health_indicators_nga.csv'
INTO TABLE raw_health_indicators
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(State, Year, Indicator_Name, Value, Source);

-- =============================================
-- 2. LOAD BUDGET ALLOCATIONS
-- Imports the 2025 fiscal data.
-- Note: Sets the default Year to 2025 automatically.
-- =============================================
LOAD DATA INFILE '../data/budget_allocations.csv'
INTO TABLE budget_allocations_2025
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(State, Budget_Category, Amount_NGN)
SET Year = 2025;

/*
  AUDIT NOTE:
  If a State in the CSV does not match 'nigeria_states_master',
  this script will throw a Foreign Key Error. 
  This is intentional to prevent bad data integrity.
*/
