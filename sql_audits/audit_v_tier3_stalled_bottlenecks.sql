/*
===============================================================================
FILE: audit_v_tier3_stalled_bottlenecks.sql
PROJECT: driiiportfolio.workday_student
OBJECT: v_tier3_stalled_bottlenecks

PURPOSE:
Operational bottleneck and SLA performance audit.

KEY FINDINGS:
- 317 stalled student cases
- Average delay: 63.58 hours
- Maximum delay: 166.91 hours
- 51.1% require ISIR verification
- Waco campus is primary bottleneck source
- Largest SLA violations occur in:
    • Enrollment_Coach
    • Central_IT_Architect
    • Financial_Aid_Partner

AUTHOR: Daniel Rodriguez III
===============================================================================
*/

-- ============================================================================
-- 1. High-Level Operational Metrics
-- ============================================================================

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT student_id) AS distinct_students,
    ROUND(AVG(elapsed_time_hours), 2) AS avg_elapsed_time_hours,
    MAX(elapsed_time_hours) AS max_elapsed_time_hours,
    COUNTIF(isir_verification_required = 1)
        AS isir_verification_required_count
FROM `driiiportfolio.workday_student.v_tier3_stalled_bottlenecks`;

-- ============================================================================
-- 2. SLA Bottleneck Analysis
-- ============================================================================

SELECT
    assigned_security_group,
    bp_step_status,
    operational_sla_status,
    COUNT(*) AS count_records,
    ROUND(AVG(elapsed_time_hours), 2) AS avg_elapsed_hours
FROM `driiiportfolio.workday_student.v_tier3_stalled_bottlenecks`
GROUP BY
    assigned_security_group,
    bp_step_status,
    operational_sla_status
ORDER BY count_records DESC;

-- ============================================================================
-- 3. Campus + Program Bottleneck Analysis
-- ============================================================================

SELECT
    campus_location,
    program_of_study,
    COUNT(*) AS count_records,
    ROUND(AVG(elapsed_time_hours), 2) AS avg_elapsed_hours
FROM `driiiportfolio.workday_student.v_tier3_stalled_bottlenecks`
GROUP BY
    campus_location,
    program_of_study
ORDER BY count_records DESC;

-- ============================================================================
-- 4. Application Status vs ISIR Impact
-- ============================================================================

SELECT
    application_status,
    isir_verification_required,
    COUNT(*) AS count_records,
    ROUND(AVG(elapsed_time_hours), 2) AS avg_elapsed_hours
FROM `driiiportfolio.workday_student.v_tier3_stalled_bottlenecks`
GROUP BY
    application_status,
    isir_verification_required
ORDER BY count_records DESC;

-- ============================================================================
-- 5. Highest-Risk Cases
-- ============================================================================

SELECT
    student_id,
    assigned_security_group,
    bp_step_status,
    elapsed_time_hours,
    operational_sla_status
FROM `driiiportfolio.workday_student.v_tier3_stalled_bottlenecks`
ORDER BY elapsed_time_hours DESC
LIMIT 50;

-- ============================================================================
-- 6. Security Group SLA Dashboard Feed
-- ============================================================================

SELECT
    assigned_security_group,
    COUNT(*) AS stalled_cases,
    ROUND(AVG(elapsed_time_hours), 2) AS avg_delay_hours,
    MAX(elapsed_time_hours) AS max_delay_hours
FROM `driiiportfolio.workday_student.v_tier3_stalled_bottlenecks`
GROUP BY assigned_security_group
ORDER BY stalled_cases DESC;
