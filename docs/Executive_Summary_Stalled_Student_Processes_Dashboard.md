# Executive_Summary_Stalled_Student_Processes_Dashboard.md
---
##### **Texas State Technical College**
##### **Workday Student Analyst:** Daniel Rodriguez III
##### **Date:** July 10, 2026

---

# Executive Summary: Stalled Student Processes Dashboard Insights

## Introduction

This document provides an executive summary of the Looker Studio dashboard, "Project Clean Slate: Stalled Student Processes Dashboard." This interactive dashboard is a critical tool for Workday Student Analysts and enrollment stakeholders, designed to provide real-time visibility into operational bottlenecks within TSTC's multi-campus student enrollment and financial aid processes. By leveraging data from the `v_tier3_stalled_bottlenecks` BigQuery view, the dashboard transforms raw data into actionable insights, enabling rapid intervention and strategic process improvements.

## Dashboard Page Title: "Stalled Student Processes Overview"

## Key Performance Indicators (KPIs)

The dashboard features several KPIs that offer immediate, high-level insights into the scale and impact of stalled student records:

1.  **Total Stalled Records:**
    *   **Insight:** This KPI presents the total count of student records currently stalled and requiring manual intervention. It serves as the primary indicator of the overall workload and problem magnitude.
    *   **Data Story:** A high number here immediately signals significant processing backlogs and a heavy burden on resolution teams, directly quantifying the challenge of "Intervening in Tier 3 System Blockages."

2.  **Average Process Delay (Hours):**
    *   **Insight:** Displays the average time student records remain stalled in the system.
    *   **Data Story:** This metric directly reflects the efficiency of bottleneck resolution. An increasing average indicates declining operational velocity and highlights systemic issues that extend beyond individual cases, informing the analyst's "Problem-Solving" efforts.

3.  **Maximum Process Delay (Hours):**
    *   **Insight:** Identifies the longest duration a single student record has been stalled.
    *   **Data Story:** This KPI flags extreme cases that demand immediate attention, potentially indicating a severely broken process or a unique, high-impact student situation. It is crucial for prioritizing urgent matters and investigating root causes to prevent future occurrences, aligning with "Identifying Flawed Validation Rules."

4.  **Critical Risk Students (ISIR Verification Required):**
    *   **Insight:** Quantifies students who have both an active hold and require federal ISIR verification (related to financial aid).
    *   **Data Story:** This KPI highlights the highest-priority cases, especially concerning financial aid, which is a major pain point identified in the problem statement. It supports "Deploying Exception Tracking Models" by focusing intervention on students with critical financial aid dependencies.

## Key Charts & Tables

Beyond high-level KPIs, the dashboard provides granular breakdowns for deeper analysis:

1.  **Multi-Campus Breakdown Chart:**
    *   **Insight:** A horizontal bar chart that visualizes the distribution of stalled student records across different campus locations.
    *   **Data Story:** This chart quickly identifies geographical hotspots where processing bottlenecks are most prevalent. For example, if the Waco campus shows a disproportionately high number of stalled records, it points to localized operational or configuration issues. This insight is vital for "Ensuring Data Synchronicity across campuses" and guiding targeted resource allocation.

2.  **Breakdown by Security Group and SLA Status Table:**
    *   **Insight:** A detailed table showing stalled records and their average delays, categorized by the responsible resolution team (e.g., Financial Aid Partner, Enrollment Coach) and their operational SLA status.
    *   **Data Story:** This table provides actionable intelligence by identifying which resolution teams are overwhelmed or where specific Service Level Agreement (SLA) violations are most frequent. It directly supports "Updating Business Process Routing Constraints" and "Troubleshooting & User Support" by informing process improvements, targeted training needs, or resource re-allocation for the analyst.

## Self-Serve Filter Matrix

*   **Insight:** Interactive drop-down filters for `campus_location`, `program_of_study`, and `assigned_security_group`.
*   **Data Story:** This feature empowers end-users, such as enrollment coaches or admissions directors, to perform ad-hoc analysis. They can quickly narrow down the dashboard's data to a specific campus, program, or responsible team without requiring direct analyst intervention for every query. This enhances "Reporting and Data Analysis" capabilities and demonstrates a scalable approach to providing self-service insights.

## Conclusion: A Comprehensive Data Story for the Workday Student Analyst

Collectively, these KPIs and charts weave a comprehensive data story crucial for a Workday Student Analyst. The dashboard begins by outlining the overall scale of the problem (Total Stalled Records, Average/Max Delay), then pinpoints critical cases (ISIR Verification Required), identifies geographical concentrations (Multi-Campus Breakdown), and finally provides actionable details about responsible teams and their performance against SLAs (Breakdown by Security Group and SLA Status).

This structured approach demonstrates advanced reporting and analytical skills, aligning perfectly with the job description's requirements for maintaining system accuracy, troubleshooting issues, and contributing to process improvements within the Workday Student system. It moves beyond simple data presentation to offer a dynamic, real-time operational analytics canvas that empowers stakeholders and enables proactive, data-driven decision-making to optimize the enrollment experience at TSTC.
