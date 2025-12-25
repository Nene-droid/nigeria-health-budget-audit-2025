# 🇳🇬 Nigeria 2025 Health Budget Audit: Forensic Gap Analysis

**Auditor:** AmakaData | **Tool Stack:** SQL, Python, Power BI  
**Status:** 🔴 Critical Anomalies Detected  

---

## 📌 Executive Summary
This forensic audit evaluates the integrity of Nigeria's **2025 Health Budget Allocation** against reported maternal and infant mortality outcomes. 

By cross-referencing fiscal appropriations with HMIS (Health Management Information System) data, this project identifies **"Fiscal Black Holes"**—regions that absorb high capital expenditure but lack verifiable health outcomes.

### 🚩 Key Findings
* **Ghost States Detected:** Two states (Kano, Delta) received >₦7 Billion combined but submitted **zero** maternal health records for the fiscal year.
* **The "Abuja Gap":** 85% of states failed to meet the 15% budgetary allocation target set by the Abuja Declaration.
* **Administrative Bloat:** Forensic analysis flagged **₦6 Billion** allocated to "Travel & Logistics" in the FCT, exceeding Clinical Services funding by 200%.

---

## 📂 Audit Architecture

| Component | File | Function |
| :--- | :--- | :--- |
| **The Foundation** | [`schema_setup.sql`](scripts/schema_setup.sql) | Enforces 3NF Normalization & Referential Integrity. |
| **The ETL Engine** | [`import_data.sql`](scripts/import_data.sql) | Automates ingestion of CSV datasets into SQL tables. |
| **The Brain** | [`audit_queries.sql`](scripts/audit_queries.sql) | Detecting anomalies, Z-Score outliers, and data deserts. |
| **The Alarm** | [`automated_alert_system.sql`](scripts/automated_alert_system.sql) | Stored Procedure to auto-flag high-risk states. |

---

## 🔍 Forensic Methodology

### 1. The "Bullshit Detector" (Fiscal Ratio Analysis)
We developed a custom SQL metric to calculate the **Cost Per Reported Outcome (CPRO)**.
```sql
-- Logic: High Budget + Low Reporting = High Risk
SELECT State, (Total_Budget / NULLIF(Reports_Submitted, 0)) AS Cost_Per_Record
FROM budget_allocations
HAVING Cost_Per_Record > 50000000; -- Threshold: ₦50M per record
