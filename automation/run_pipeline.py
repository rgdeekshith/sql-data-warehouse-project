import pyodbc
import os
import re
from dotenv import load_dotenv

def get_db_connection():
    # Load the variables from the local .env file
    load_dotenv() 
    
    # Securely fetch the server and database names
    server = os.getenv('SQL_SERVER')
    database = os.getenv('SQL_DATABASE')

    conn_str = (
        "DRIVER={ODBC Driver 17 for SQL Server};"
        f"SERVER={server};" 
        f"DATABASE={database};" 
        "Trusted_Connection=yes;"
    )
    return pyodbc.connect(conn_str, autocommit=True)

def execute_sql_file(filepath, cursor):
    with open(filepath, 'r') as file:
        sql_script = file.read()
    
    sql_batches = re.split(r'(?i)^\s*GO\s*$', sql_script, flags=re.MULTILINE)
    
    for batch in sql_batches:
        if batch.strip():
            cursor.execute(batch)

def run_pipeline():
    # Determine absolute paths dynamically
    current_dir = os.path.dirname(os.path.abspath(__file__))
    base_repo_path = os.path.dirname(current_dir) 
    
    datasets_path = os.path.join(base_repo_path, 'datasets')
    original_scripts_dir = os.path.join(base_repo_path, 'scripts')

    # Define execution sequence
    pipeline_steps = [
        {"name": "Init DB & Schemas", "path": os.path.join(original_scripts_dir, "init_database_and_schema_creation.sql")},
        {"name": "Bronze DDL", "path": os.path.join(original_scripts_dir, "bronze", "ddl_bronze.sql")},
        {"name": "Bronze Load SP Creation", "path": os.path.join(current_dir, "loading_bronze_data.sql")},
    ]

    try:
        print("Starting Data Warehouse Pipeline...")
        conn = get_db_connection()
        cursor = conn.cursor()

        # Step A: Execute DDL and SP creation
        for step in pipeline_steps:
            print(f"Executing: {step['name']}")
            execute_sql_file(step["path"], cursor)

        # Step B: Trigger the data load
        print(f"\nLoading Bronze Data from: {datasets_path}")
        cursor.execute("EXEC bronze.load_bronze @BasePath = ?", datasets_path)
        
        print("\nPipeline Executed Successfully!")

    except pyodbc.Error as e:
        print(f"\nDatabase Error: {e}")
    finally:
        if 'conn' in locals():
            conn.close()

if __name__ == "__main__":
    run_pipeline()
