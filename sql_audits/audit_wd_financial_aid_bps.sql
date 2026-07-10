/*
===============================================================================
FILE: audit_wd_financial_aid_bps.sql
PROJECT: driiiportfolio.workday_student
OBJECT: wd_financial_aid_bps

PURPOSE:
Operational audit of Workday Financial Aid Business Processes.

KEY FINDINGS:
- 1 duplicate event_instance_id detected
- Duplicate key: EVT-122977
- 1,200 rows / 1,199 distinct event IDs
- No NULL values detected
- Event and Student IDs follow expected formats
- Consider converting isir_verification_required
  from INT64 to BOOLEAN

AUTHOR: Daniel Rodriguez III
===============================================================================
*/

-- ============================================================================
-- 1. Event Instance Key Integrity
-- ============================================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT event_instance_id) AS distinct_event_ids,
    COUNT(*) - COUNT(DISTINCT event_instance_id) AS duplicate_events
FROM `driiiportfolio.workday_student.wd_financial_aid_bps`;

-- ============================================================================
-- 2. Duplicate Event Investigation
-- ============================================================================

SELECT *
FROM `driiiportfolio.workday_student.wd_financial_aid_bps`
WHERE event_instance_id = 'EVT-122977';

-- ============================================================================
-- 3. Duplicate Event Detection
-- ============================================================================

SELECT
    event_instance_id,
    COUNT(*) AS duplicate_count
FROM `driiiportfolio.workday_student.wd_financial_aid_bps`
GROUP BY event_instance_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- ============================================================================
-- 4. Business Process Status Distribution
-- ============================================================================

SELECT
    bp_step_status,
    COUNT(*) AS record_count
FROM `driiiportfolio.workday_student.wd_financial_aid_bps`
GROUP BY bp_step_status
ORDER BY record_count DESC;

-- ============================================================================
-- 5. Security Group Distribution
-- ============================================================================

SELECT
    assigned_security_group,
    COUNT(*) AS record_count
FROM `driiiportfolio.workday_student.wd_financial_aid_bps`
GROUP BY assigned_security_group
ORDER BY record_count DESC;

-- ============================================================================
-- 6. ISIR Verification Distribution
-- ============================================================================

SELECT
    isir_verification_required,
    COUNT(*) AS record_count
FROM `driiiportfolio.workday_student.wd_financial_aid_bps`
GROUP BY isir_verification_required
ORDER BY record_count DESC;

-- ============================================================================
-- 7. Elapsed Time Statistical Profile
-- ============================================================================

SELECT
    MIN(elapsed_time_hours) AS min_hours,
    MAX(elapsed_time_hours) AS max_hours,
    ROUND(AVG(elapsed_time_hours), 2) AS avg_hours,
    ROUND(STDDEV(elapsed_time_hours), 2) AS stddev_hours
FROM `driiiportfolio.workday_student.wd_financial_aid_bps`;

-- ============================================================================
-- 8. Event ID Format Validation
-- ============================================================================

SELECT *
FROM `driiiportfolio.workday_student.wd_financial_aid_bps`
WHERE NOT REGEXP_CONTAINS(event_instance_id, r'^EVT-\d{6}$');

-- ============================================================================
-- 9. Student ID Format Validation
-- ============================================================================

SELECT *
FROM `driiiportfolio.workday_student.wd_financial_aid_bps`
WHERE NOT REGEXP_CONTAINS(student_id, r'^STU-\d{5}$');

-- Expected Result:
-- Zero rows returned.
