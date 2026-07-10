# EIB Validation Matrix: Spreadsheet Logic to BigQuery Translation

This document outlines how functionalities commonly performed in spreadsheets for data validation and enrichment can be scaled and automated using robust database systems like BigQuery. The `v_tier3_stalled_bottlenecks` view serves as a key example of this translation.

## 1. `XLOOKUP` Equivalence (Cross-Module Tenant Enrichment)

*   **Original Spreadsheet Purpose:** The `XLOOKUP` function (`=XLOOKUP(A2, 'wd_financial_aid_bps'!B:B, 'wd_financial_aid_bps'!F:F, "No Financial Record Match")`) in Google Sheets is used to enrich admissions data with financial aid information. It looks up a `student_id` and returns the corresponding `isir_verification_required` status.

*   **BigQuery Implementation:** In the BigQuery view, this cross-referencing and data enrichment are achieved through an **`INNER JOIN`** statement:

    ```sql
    FROM `driiiportfolio.workday_student.wd_admissions_pipeline` AS adm
    INNER JOIN `driiiportfolio.workday_student.wd_financial_aid_bps` AS bp
        ON adm.student_id = bp.student_id
    ```

    This `INNER JOIN` matches records from the admissions and financial aid tables based on their common `student_id`, effectively combining the datasets and making the `isir_verification_required` status available, similar to how `XLOOKUP` would.

## 2. `IFS` Equivalence (Multi-Campus Compliance Flagging)

*   **Original Spreadsheet Purpose:** The `IFS` function (`=IFS(AND(E2=1, F2=1), "CRITICAL: Audit Hold & Action Required", AND(E2=1, F2=0), "Standard Operational Hold", TRUE, "Clean Pipeline Status")`) in Google Sheets applies conditional logic to categorize records based on multiple criteria, such as `active_registration_hold` and `isir_verification_required`.

*   **BigQuery Implementation:** The conditional logic of the `IFS` function is replicated in BigQuery using a **`CASE`** statement to create the `operational_sla_status` field. This `CASE` statement focuses on classifying records based on **process latency** (elapsed time):

    ```sql
    CASE
        WHEN bp.elapsed_time_hours > 48.0 THEN 'SLA Violation: Immediate Escalation Required'
        WHEN bp.elapsed_time_hours BETWEEN 24.0 AND 48.0 THEN 'Warning: Approaching Threshold'
        ELSE 'Within Acceptable Parameters'
    END AS operational_sla_status
    ```

    This `CASE` statement evaluates `elapsed_time_hours` and assigns a categorical status, providing a dynamic and analytically powerful flag that addresses the project's goal of identifying and prioritizing stalled records based on operational service level agreements. This BigQuery approach offers a more robust, scalable, and auditable solution compared to manual spreadsheet formulas.
