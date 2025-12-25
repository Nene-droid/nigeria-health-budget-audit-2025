/*
  PROJECT: Nigeria 2025 Health Budget Audit
  FILE: schema_setup.sql
  PURPOSE: Creates the database structure with strict Referential Integrity.
  AUTHOR: AmakaData
*/

-- =============================================
-- 1. Master Table: Nigerian States
-- Source of truth for all 36 States + FCT.
-- Prevents "Ghost States" from entering the system.
-- =============================================
CREATE TABLE IF NOT EXISTS nigeria_states_master (
    State_ID INT PRIMARY KEY,
    State_Name VARCHAR(50) NOT NULL UNIQUE,
    Region VARCHAR(50)
);

-- =============================================
-- 2. Health Data Table
-- Stores raw mortality and health outcome records.
-- Linked to Master Table to ensure data quality.
-- =============================================
CREATE TABLE IF NOT EXISTS raw_health_indicators (
    Record_ID INT PRIMARY KEY AUTO_INCREMENT,
    State VARCHAR(50),
    Year INT,
    Indicator_Name VARCHAR(100),
    Value DECIMAL(10,2),
    Source VARCHAR(50),
    FOREIGN KEY (State) REFERENCES nigeria_states_master(State_Name)
);

-- =============================================
-- 3. Budget Table
-- Stores 2025 fiscal allocations.
-- Linked to Master Table to track spending per state.
-- =============================================
CREATE TABLE IF NOT EXISTS budget_allocations_2025 (
    Allocation_ID INT PRIMARY KEY AUTO_INCREMENT,
    State VARCHAR(50),
    Year INT DEFAULT 2025,
    Budget_Category VARCHAR(100),
    Amount_NGN DECIMAL(20,2), -- High precision for Billions
    FOREIGN KEY (State) REFERENCES nigeria_states_master(State_Name)
);

-- =============================================
-- 4. Seed Data (Initial Setup)
-- Populates the Master Table immediately.
-- =============================================
INSERT IGNORE INTO nigeria_states_master (State_ID, State_Name, Region) VALUES
(1, 'Abia', 'South-East'), (2, 'Adamawa', 'North-East'), (3, 'Akwa Ibom', 'South-South'),
(4, 'Anambra', 'South-East'), (5, 'Bauchi', 'North-East'), (6, 'Bayelsa', 'South-South'),
(7, 'Benue', 'North-Central'), (8, 'Borno', 'North-East'), (9, 'Cross River', 'South-South'),
(10, 'Delta', 'South-South'), (11, 'Ebonyi', 'South-East'), (12, 'Edo', 'South-South'),
(13, 'Ekiti', 'South-West'), (14, 'Enugu', 'South-East'), (15, 'Gombe', 'North-East'),
(16, 'Imo', 'South-East'), (17, 'Jigawa', 'North-West'), (18, 'Kaduna', 'North-West'),
(19, 'Kano', 'North-West'), (20, 'Katsina', 'North-West'), (21, 'Kebbi', 'North-West'),
(22, 'Kogi', 'North-Central'), (23, 'Kwara', 'North-Central'), (24, 'Lagos', 'South-West'),
(25, 'Nasarawa', 'North-Central'), (26, 'Niger', 'North-Central'), (27, 'Ogun', 'South-West'),
(28, 'Ondo', 'South-West'), (29, 'Osun', 'South-West'), (30, 'Oyo', 'South-West'),
(31, 'Plateau', 'North-Central'), (32, 'Rivers', 'South-South'), (33, 'Sokoto', 'North-West'),
(34, 'Taraba', 'North-East'), (35, 'Yobe', 'North-East'), (36, 'Zamfara', 'North-West'),
(37, 'FCT', 'North-Central');
