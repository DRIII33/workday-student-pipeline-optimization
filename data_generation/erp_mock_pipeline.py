import pandas as pd
import numpy as np
import random
from datetime import datetime, timedelta

# Set seed for reproducibility across portfolio reviews
np.random.seed(42)
random.seed(42)

num_records = 1200
student_ids = [f"STU-{i:05d}" for i in range(10001, 10001 + num_records)]
campuses = ["Waco", "North Texas", "Williamson County"]
programs = ["Cybersecurity", "Welding Labs", "Diesel Equipment", "Automation & Advanced Manufacturing"]
app_statuses = ["Applied", "Admitted", "Matriculated"]
security_groups = ["Financial_Aid_Partner", "Central_IT_Architect", "Enrollment_Coach"]

# Generate structural admissions data
admissions_data = {
    "student_id": student_ids,
    "campus_location": [random.choice(campuses) for _ in range(num_records)],
    "program_of_study": [random.choice(programs) for _ in range(num_records)],
    "application_status": [random.choice(app_statuses) for _ in range(num_records)],
    "active_registration_hold": [np.random.choice([0, 1], p=[0.75, 0.25]) for _ in range(num_records)]
}
df_admissions = pd.DataFrame(admissions_data)

# Force systematic business process blockages on the Waco campus
df_admissions.loc[df_admissions['campus_location'] == 'Waco', 'active_registration_hold'] = \
    [np.random.choice([0, 1], p=[0.40, 0.60]) for _ in range(len(df_admissions[df_admissions['campus_location'] == 'Waco']))]

# Generate accompanying Workday Business Process logs
bp_data = {
    "event_instance_id": [f"EVT-{random.randint(100000, 999999)}" for _ in range(num_records)],
    "student_id": student_ids,
    "bp_step_status": [random.choice(["Approved", "Awaiting Action", "Exception"]) for _ in range(num_records)],
    "assigned_security_group": [random.choice(security_groups) for _ in range(num_records)],
    "elapsed_time_hours": [round(random.uniform(0.1, 72.0), 2) for _ in range(num_records)],
    "isir_verification_required": [random.choice([0, 1]) for _ in range(num_records)]
}
df_bp = pd.DataFrame(bp_data)

# Induce critical system delays for stalled records
df_bp.loc[df_bp['bp_step_status'] == 'Awaiting Action', 'elapsed_time_hours'] = \
    [round(random.uniform(24.5, 168.0), 2) for _ in range(len(df_bp[df_bp['bp_step_status'] == 'Awaiting Action']))]

# Export to CSV formats representing Workday Custom Report Outputs
df_admissions.to_csv("wd_admissions_pipeline.csv", index=False)
df_bp.to_csv("wd_financial_aid_bps.csv", index=False)

print(f"Successfully configured and outputted {num_records} mock records for ecosystem auditing.")
