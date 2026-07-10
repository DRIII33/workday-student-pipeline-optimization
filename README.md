# Project Clean Slate: Optimizing Multi-Campus Enrollment Registration Mechanics
---
##### **Texas State Technical College**
##### **Workday Student Analyst:** Daniel Rodriguez III
##### **Date:** July 10, 2026

---
## Executive Summary

This project, "Project Clean Slate," addresses critical operational bottlenecks in Texas State Technical College's (TSTC) Workday Student system, specifically within the admissions and registration pipeline across its Waco, North Texas, and Williamson County campuses. TSTC's funding model is tied to graduate employment outcomes, making an efficient enrollment process paramount.

The project establishes an end-to-end data auditing framework using programmatic data cleansing (Python), relational SQL views (BigQuery), and interactive dashboards (Looker Studio). This framework is designed to identify, resolve, and audit Workday Business Process ($BP$) failures within key modules (Admissions, Records, Financial Aid, Advising), thereby reducing processing backlogs, maintaining data synchronization, and ensuring clean data for state audits.

## Problem Statement

Academic terms often begin with hundreds of students unable to complete course registration due to stalled financial aid packages in a "Pending Review" stage, triggering automated registration holds. Centralized IT lacks the localized context for manual intervention, necessitating a Workday Student Analyst to resolve these Tier 3 system blockages. This involves identifying flawed validation rules, updating business process routing constraints, and deploying exception tracking models to manage messy student profiles before they impact institutional enrollment metrics.

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

1.  **Programmatic Mock Data Generation (Python):** A Python script (`erp_mock_pipeline.py`) simulates student records, introducing messy formats, missing data, and intentional delays to mimic a live Workday environment.
2.  **Relational Database Staging & Analytics (Google BigQuery):** CSV outputs are uploaded to BigQuery. A SQL view (`v_tier3_stalled_bottlenecks.sql`) is created to join admissions and financial aid data, isolate stalled Tier 3 business processes, and calculate exact wait times.
3.  **Visualization & Dashboard Outputs (Looker Studio):** The BigQuery view feeds an interactive Looker Studio dashboard, providing real-time monitoring of bottlenecks with key KPIs and breakdown charts.

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
├── .github/
│   └── workflows/
│       └── data_validation_ci.yml
├── data_generation/
│   ├── __init__.py
│   └── erp_mock_pipeline.py
├── data_loading/
│   └── bigquery_loader.py
├── sql_transforms/
│   ├── architecture_schemas.json
│   └── v_tier3_stalled_bottlenecks.sql
├── sheets_templates/
│   └── eib_validation_matrix.md
└── README.md
```
