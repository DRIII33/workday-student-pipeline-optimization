# **Executive Summary:** Project Clean Slate
---
##### **Texas State Technical College**
##### **Workday Student Analyst:** Daniel Rodriguez III
##### **Date:** July 10, 2026

---
## I. Project Title

**Project Clean Slate: Optimizing Multi-Campus Enrollment Registration Mechanics via Automated Workday Business Processes and Exception-Driven Auditing Dashboards**

## II. Project Summary (Executive Overview)

Texas State Technical College (TSTC) operates under a **Returned-Value Funding Model**, which directly links its legislative budget to the long-term employment outcomes and wage tracking of its graduates. This critical funding mechanism makes the efficiency of the admissions and registration pipeline paramount; any bottleneck causing an applicant to drop out before full registration directly impacts institutional funding and stability.

**Project Clean Slate** establishes a robust, end-to-end data auditing framework designed to enhance operational efficiency and data integrity across TSTC's Waco, North Texas, and Williamson County campuses. This framework integrates programmatic data cleansing (Python), advanced relational SQL views (Google BigQuery), and interactive self-serve dashboards (Looker Studio).

The primary objective is to isolate, resolve, and continuously audit **Workday Business Process ($BP$)** failures within key modules, including *Admissions, Records, Financial Aid, and Advising*. By automating the identification and analysis of these bottlenecks, the project aims to significantly reduce processing backlogs before registration deadlines, ensure consistent and synchronized employee and student data across all campuses, and provide clean, auditable data structures essential for state compliance and reporting.

## III. Problem Statement

Prior to major academic terms, TSTC's cross-campus enrollment pipelines frequently encounter severe operational bottlenecks. Hundreds of incoming students are unable to complete course registration because their financial aid packages become stalled in an unresolved "Pending Review" stage, leading to automated registration holds across multiple campuses.

The centralized IT department, lacking the localized business context, is ill-equipped to manually resolve thousands of individual file errors. This necessitates the intervention of a Workday Student Analyst. The analyst's crucial role involves addressing these Tier 3 system blockages by identifying flawed validation rules within Workday, updating critical business process routing constraints, and deploying advanced exception tracking models to effectively manage messy or incomplete student profiles before they negatively impact institutional enrollment metrics and TSTC's funding model.

## IV. Dataset Description & Production Schemas

The analytical architecture of Project Clean Slate processes mock student records within Google BigQuery under the Public Project ID: `driiiportfolio`. The system primarily leverages two interconnected entities:

### 1. `driiiportfolio.workday_student.wd_admissions_pipeline`

This table tracks individual student applications and monitors registration holds across TSTC's multi-campus technical programs. Its schema includes:
*   `student_id` (STRING, REQUIRED): Unique primary identifier for each student.
*   `campus_location` (STRING, NULLABLE): The specific physical campus operational zone (e.g., Waco, North Texas, Williamson County).
*   `program_of_study` (STRING, NULLABLE): The technical trade pathway a student is pursuing (e.g., Cybersecurity, Welding, Diesel Equipment, Automation & Advanced Manufacturing).
*   `application_status` (STRING, NULLABLE): The student's current stage in the application pipeline (e.g., Applied, Admitted, Matriculated).
*   `active_registration_hold` (INT64, NULLABLE): A binary flag indicating the presence of an active registration hold ($1 = \text{True}$, $0 = \text{False}$). (Note: `INT64` is used instead of `BOOL` as `INT64` maps directly to `boolean` in BigQuery when `0` or `1` are used).

### 2. `driiiportfolio.workday_student.wd_financial_aid_bps`

This table captures system event logs and step timings specifically for the core business process: `Propose_Financial_Aid_Package`. Its schema comprises:
*   `event_instance_id` (STRING, REQUIRED): A unique alphanumeric string identifying each system event.
*   `student_id` (STRING, REQUIRED): A foreign key linking to the `wd_admissions_pipeline` to connect financial aid events to specific students.
*   `bp_step_status` (STRING, NULLABLE): The operational status of the business process step (e.g., Approved, Awaiting Action, Exception).
*   `assigned_security_group` (STRING, NULLABLE): The targeted resolution tier or team responsible for the step (e.g., Financial_Aid_Partner, Central_IT_Architect, Enrollment_Coach).
*   `elapsed_time_hours` (FLOAT64, NULLABLE): The total duration (in hours) a record has remained at its current business process step.
*   `isir_verification_required` (INT64, NULLABLE): A binary indicator for federal verification profiles ($1 = \text{True}$, $0 = \text{False}$). (Note: `INT64` is used instead of `BOOL` as `INT64` maps directly to `boolean` in BigQuery when `0` or `1` are used).

## V. Methodology & Technical Execution

Project Clean Slate employs a structured, three-phase methodology to achieve its objectives:

1.  **Programmatic Mock Data Generation (Python Pipeline):**
    *   **Tool:** Google Colab (Python) simulating Workday Extend/PySpark Data Pipelines.
    *   **Process:** A Python script (`erp_mock_pipeline.py`) is developed and executed in Google Colab. This script programmatically generates a synthetic dataset that mimics student records, intentionally introducing messy data formats, missing data strings, and simulated business process delays. This robust simulation accurately reflects the complexities and error-prone nature of a live Workday environment, providing a realistic basis for analysis.

2.  **Relational Database Staging & Analytics (Google BigQuery):**
    *   **Tool:** Google BigQuery simulating Snowflake/Microsoft SQL Server.
    *   **Process:** The generated CSV data files are programmatically uploaded to dedicated tables within Google BigQuery. A sophisticated SQL view (`v_tier3_stalled_bottlenecks.sql`) is then materialized. This view performs crucial data transformations by joining admissions and financial aid data, isolating only those student records that are actively stalled within Tier 3 business processes, and precisely calculating their exact wait times. This ensures that only relevant, actionable data is surfaced for analysis.

3.  **Visualization & Dashboard Outputs (Looker Studio):**
    *   **Tool:** Looker Studio simulating Workday Discovery Boards/Tableau.
    *   **Process:** The clean, transformed data from the BigQuery view (`v_tier3_stalled_bottlenecks`) directly feeds an interactive Looker Studio dashboard. This dashboard serves as a real-time monitoring and reporting tool, visually highlighting key bottlenecks through intuitive KPIs and breakdown charts. This final stage provides immediate, actionable insights to stakeholders, enabling them to quickly identify and address stalled student records and improve overall enrollment velocity.
