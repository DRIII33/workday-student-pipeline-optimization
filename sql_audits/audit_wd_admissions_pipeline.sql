/*
===============================================================================
FILE: audit_wd_admissions_pipeline.sql
PROJECT: driiiportfolio.workday_student
OBJECT: wd_admissions_pipeline

PURPOSE:
Data quality audit for admissions pipeline records.

SUMMARY OF FINDINGS:
- 1,200 total records
- 1,200 distinct student_id values
- No NULL values detected
- No duplicate student records detected
- Standardized campus locations
- Standardized program names
- Standardized application statuses
- Ready for reporting, analytics, and predictive modeling

AUTHOR: Daniel Rodriguez III
===============================================================================
*/

-- ============================================================================
-- 1. Record Count & Primary Key Integrity
-- ============================================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT student_id) AS distinct_students,
    COUNTIF(student_id IS NULL) AS null_student_ids,
    COUNTIF(campus_location IS NULL) AS null_campus_locations,
    COUNTIF(program_of_study IS NULL) AS null_program_of_studies,
    COUNTIF(application_status IS NULL) AS null_application_statuses,
    COUNTIF(active_registration_hold IS NULL) AS null_active_registration_holds
FROM `driiiportfolio.workday_student.wd_admissions_pipeline`;

-- ============================================================================
-- 2. Campus Location Standardization Audit
-- ============================================================================

SELECT
    campus_location,
    COUNT(*) AS record_count
FROM `driiiportfolio.workday_student.wd_admissions_pipeline`
GROUP BY campus_location
ORDER BY record_count DESC;

-- ============================================================================
-- 3. Program of Study Standardization Audit
-- ============================================================================

SELECT
    program_of_study,
    COUNT(*) AS record_count
FROM `driiiportfolio.workday_student.wd_admissions_pipeline`
GROUP BY program_of_study
ORDER BY record_count DESC;

-- ============================================================================
-- 4. Application Status Distribution
-- ============================================================================

SELECT
    application_status,
    COUNT(*) AS record_count
FROM `driiiportfolio.workday_student.wd_admissions_pipeline`
GROUP BY application_status
ORDER BY record_count DESC;

-- ============================================================================
-- 5. Registration Hold Distribution
-- ============================================================================

SELECT
    active_registration_hold,
    COUNT(*) AS record_count
FROM `driiiportfolio.workday_student.wd_admissions_pipeline`
GROUP BY active_registration_hold
ORDER BY record_count DESC;

-- ============================================================================
-- 6. Duplicate Student Detection
-- ============================================================================

SELECT
    student_id,
    COUNT(*) AS duplicate_count
FROM `driiiportfolio.workday_student.wd_admissions_pipeline`
GROUP BY student_id
HAVING COUNT(*) > 1;

-- Expected Result:
-- Zero rows returned.
