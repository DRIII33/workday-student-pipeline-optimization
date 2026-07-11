# Project Clean Slate: Optimizing Multi-Campus Enrollment Registration Mechanics
---
##### **Texas State Technical College**
##### **Workday Student Analyst:** Daniel Rodriguez III
##### **Date:** July 10, 2026

---
## Executive Summary

This project, "Project Clean Slate," addresses critical operational bottlenecks in Texas State Technical College's (TSTC) Workday Student system, specifically within the admissions and registration pipeline. By identifying and resolving stalled financial aid processing that triggers registration holds, this framework enables faster student enrollment and ensures compliance with federal financial aid requirements.

The project establishes an end-to-end data auditing framework using programmatic data cleansing (Python), relational SQL views (BigQuery), and interactive dashboards (Looker Studio). This framework is designed to serve as both a diagnostic tool for identifying enrollment bottlenecks and a scalable model for continuous process monitoring across TSTC's multi-campus system.

## Problem Statement

Academic terms often begin with hundreds of students unable to complete course registration due to stalled financial aid packages in a "Pending Review" stage, triggering automated registration holds. This bottleneck prevents enrollment, delays revenue recognition, and creates federal compliance risk if FAFSA and ISIR verification data falls out of sync with system records.

The centralized IT department, lacking localized business context, is ill-equipped to manually resolve thousands of individual file errors. This necessitates the intervention of a dedicated Workday Student Analyst role capable of identifying root causes, implementing preventive controls, and supporting enrollment staff through system issues and process improvements.

## Video Demonstration

**Project Clean Slate Dashboard Walkthrough**

A comprehensive video demonstration of the Looker Studio dashboard is available on LinkedIn, showing:
- 📊 **KPI Card Navigation:** Total Stalled Records, Average Process Delay, Maximum Process Delay, Critical Risk Volume (ISIR Verification)
- 🗺️ **Multi-Campus Breakdown Visualization:** Distribution of stalled records by campus location (Waco, North Texas, Williamson County)
- 👥 **Security Group & SLA Status Analysis:** Resolution team performance and service level agreement compliance metrics
- 🔍 **Interactive Filter Functionality:** Real-time drill-down by campus location, program of study, and assigned resolution group

👉 **Watch on LinkedIn:** [Project Clean Slate Dashboard Walkthrough](https://www.linkedin.com/feed/update/urn:li:activity:7481835211295485952/)

*Note: Video content provides interactive demonstration of dashboard capabilities and system architecture understanding. Static documentation and technical implementation details available in `/docs/` and `/sql_transforms/` folders.*

---

## Dataset Description & Production Schemas

The analytical architecture processes mock records across two primary entities in Google BigQuery under the Public Project ID: `driiiportfolio.workday_student`.

### `wd_admissions_pipeline`
Tracks individual student applications and registration holds.

*   `student_id` (STRING, REQUIRED): Unique internal primary student identifier.
*   `campus_location` (STRING, NULLABLE): Specific physical campus operational zone.
*   `program_of_study` (STRING, NULLABLE): Technical trade pathway.
*   `application_status` (STRING, NULLABLE): Current pipeline lifecycle stage.
*   `active_registration_hold` (INT64, NULLABLE): Binary indicator flags (1=True, 0=False).

### `wd_financial_aid_bps`
Captures system event logs and step timings for the core business process: `Propose_Financial_Aid_Package`.

*   `event_instance_id` (STRING, REQUIRED): Unique alphanumeric system event string.
*   `student_id` (STRING, REQUIRED): Foreign key connecting to the admissions pipeline.
*   `bp_step_status` (STRING, NULLABLE): Operational state of the step (Approved, Awaiting Action, Exception).
*   `assigned_security_group` (STRING, NULLABLE): Targeted resolution tier.
*   `elapsed_time_hours` (FLOAT64, NULLABLE): Total processing time the record has remained at the current step.
*   `isir_verification_required` (INT64, NULLABLE): Binary indicator for federal verification profiles (1=True, 0=False).

## Methodology & Technical Execution

1.  **Programmatic Mock Data Generation (Python):** A Python script (`erp_mock_pipeline.py`) simulates student records, introducing messy formats, missing data, and intentional delays to mimic a live system. Dataset includes 1,200 records across three campus locations with realistic program-to-campus distributions and hold status patterns.
2.  **Relational Database Staging & Analytics (Google BigQuery):** CSV outputs are uploaded to BigQuery. A SQL view (`v_tier3_stalled_bottlenecks.sql`) is created to join admissions and financial aid data, identifying stalled records, quantifying delays, and flagging high-risk cases. Comprehensive audit queries validate data quality and identify bottleneck patterns.
3.  **Visualization & Dashboard Outputs (Looker Studio):** The BigQuery view feeds an interactive Looker Studio dashboard, providing real-time monitoring of bottlenecks with key KPIs and breakdown charts. Dashboard enables multi-campus coordination, team performance tracking, and executive reporting.

## Key Features & Metrics

*   **SLA Compliance Flag:** Categorizes records based on processing delays, identifying those exceeding 48 hours.
*   **Tier 3 Resolution Velocity (Hours):** Tracks the duration a record is stuck at an active step, with a target under 24 hours.
*   **Multi-Campus Defect Rate (%):** Proportion of records within a campus area failing validation, targeting less than 0.5%.

## Visualization & Dashboard Outputs

**Looker Studio Operational Analytics Canvas (Page Title: "Stalled Student Processes Overview")**

*   **Top KPI Performance Cards:** Total Stalled Records, Average Delay Metrics, Critical Risk Volume (ISIR verification).
*   **Multi-Campus Breakdown Chart:** Horizontal bar chart showing stalled records by campus location.
*   **Breakdown by Security Group and SLA Status:** Table detailing stalled records and average delays by resolution team and SLA status.
*   **Self-Serve Filter Matrix:** Drop-down filters for `campus_location`, `program_of_study`, and `assigned_security_group` for granular analysis.

## Strategic Recommendations

*   **Deploy Targeted Automated Validation Rules:** Update Workday BPs to automatically clear simple, non-verification files.
*   **Implement an Early-Warning Exception Schedule:** Configure BigQuery exception view to run weekly, providing proactive alerts to enrollment coaches.
*   **Standardize Testing for Bi-Annual System Updates:** Use data cleaning scripts for routine testing in sandbox environments to prevent production impacts.

## Repository Architecture

```
workday-student-pipeline-optimization/
├── data/
│   ├── wd_admissions_pipeline.csv
│   └── wd_financial_aid_bps.csv
│
├── data_generation/
│   └── erp_mock_pipeline.py
│
├── data_loading/
│   └── bigquery_loader.py
│
├── docs/
│   ├── Executive_Summary.md
│   ├── Executive_Summary_Stalled_Student_Processes_Dashboard.md
│   └── Project_Disclaimer.md
│
├── sheets_templates/
│   └── eib_validation_matrix.md
│
├── sql_audits/
│   ├── audit_v_tier3_stalled_bottlenecks.sql
│   ├── audit_wd_admissions_pipeline.sql
│   └── audit_wd_financial_aid_bps.sql
│
├── sql_transforms/
│   ├── architecture_schemas.json
│   └── v_tier3_stalled_bottlenecks.sql
│
└── README.md
```

---

## Project Disclaimer

**Project Scope & Accuracy:** Project Clean Slate is an independent professional portfolio piece authored by Daniel Rodriguez III, designed to demonstrate Workday Student system optimization capabilities and advanced enrollment data analytics expertise. The project employs mock student records and simulated data generated for analytical framework demonstration purposes. All operational scenarios, architectural workflows, and performance metrics are derived from rigorous independent research utilizing publicly available information regarding higher education enrollment operations and Workday Student system functionality. This project is a theoretical analysis and framework design—not a real-time report of TSTC's actual enrollment data or system configuration.

**Non-Affiliation:** This project is not affiliated with, endorsed by, or developed in partnership with Texas State Technical College. The project is provided as evidence of professional competency relevant to higher education ERP system analysis, data governance, and enrollment operations optimization.

**Data Privacy & Compliance:** All student identifiers, campus names, and institutional details referenced in the project are either mock data, publicly available information, or anonymized references used for analytical framework demonstration. No actual student data, institutional records, or confidential system information is contained in this repository.

---

## Getting Started

### Prerequisites
- Google Cloud Platform (GCP) account with BigQuery access
- Python 3.8+ with pandas, numpy libraries
- Looker Studio account (free tier available)
- SQL query editor (BigQuery console or similar)

### Implementation Steps

1. **Generate Mock Data:** Execute `python data_generation/erp_mock_pipeline.py` to create CSV datasets
2. **Load to BigQuery:** Run `python data_loading/bigquery_loader.py` to upload data (requires GCP credentials)
3. **Execute Audit Queries:** Run SQL scripts in `sql_audits/` folder to validate data quality
4. **Build Dashboard:** Import BigQuery view into Looker Studio and create visualizations per dashboard architecture
5. **Review Documentation:** See `/docs/` folder for detailed analysis and interpretation guides

### Documentation
- **Executive Summary:** See `/docs/Executive_Summary.md` for complete project context and methodology
- **Dashboard Guide:** See `/docs/Executive_Summary_Stalled_Student_Processes_Dashboard.md` for detailed KPI and chart explanations
- **Disclaimer:** See `/docs/Project_Disclaimer.md` for full project scope and data privacy information

---

## Contact & Inquiries

This portfolio project demonstrates advanced capabilities in Workday Student system analysis, SQL-based data auditing, and higher education data analytics.

**Author:** Daniel Rodriguez III  
**LinkedIn:** https://www.linkedin.com/in/daniel-rodriguez-iii-workday/  
**GitHub:** https://github.com/DRIII33

---

*Last Updated: July 11, 2026*
