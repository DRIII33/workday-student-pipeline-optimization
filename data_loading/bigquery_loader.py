import pandas as pd
import pandas_gbq
import os

# Define your Google Cloud Project ID and Dataset ID
# In a production environment, consider loading these from environment variables
# or a configuration file.
PROJECT_ID = 'driiiportfolio'  # Use the project ID where the tables are expected to reside
DATASET_ID = 'workday_student'

# Path to the generated CSV files
ADMISSIONS_CSV_PATH = 'wd_admissions_pipeline.csv'
BP_CSV_PATH = 'wd_financial_aid_bps.csv'

def upload_csv_to_bigquery(file_path, destination_table_name, project_id, dataset_id):
    """Loads a CSV file into a BigQuery table."""
    if not os.path.exists(file_path):
        print(f"Error: File not found at {file_path}")
        return

    df_load = pd.read_csv(file_path)
    table_id = f"{project_id}.{dataset_id}.{destination_table_name}"

    print(f"Uploading {file_path} to {table_id}...")
    try:
        pandas_gbq.to_gbq(
            df_load,
            destination_table=table_id,
            project_id=project_id,
            if_exists='replace',  # Replace table if it already exists
            progress_bar=True
        )
        print(f"{file_path} uploaded successfully to {table_id}.")
    except Exception as e:
        print(f"Error uploading {file_path} to BigQuery: {e}")

if __name__ == "__main__":
    # Ensure the dataset 'workday_student' exists in your BigQuery project.
    # It can be created manually or programmatically using bigquery.Client().create_dataset()

    # Upload admissions data
    upload_csv_to_bigquery(ADMISSIONS_CSV_PATH, 'wd_admissions_pipeline', PROJECT_ID, DATASET_ID)

    # Upload business process data
    upload_csv_to_bigquery(BP_CSV_PATH, 'wd_financial_aid_bps', PROJECT_ID, DATASET_ID)
