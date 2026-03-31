import pyodbc
import os
import re
from dotenv import load_dotenv

def get_db_connection():
    """
    Connects to SQL Server using credentials stored in a local .env file.
    This keeps the script portable across different machines.
    """
    # Load settings from the .env file
    load_dotenv() 
    
    server = os.getenv('SQL_SERVER')
    database = os.getenv('SQL_DATABASE')

    # Construct the connection string using the 'f-string' format for readability
    conn_str = (
        "DRIVER={ODBC Driver 17 for SQL Server};"
        f"SERVER={server};" 
        f"DATABASE={database};" 
        "Trusted_Connection=yes;"
    )
    # autocommit=True is used so that each SQL command is finalized immediately
    return pyodbc.connect(conn_str, autocommit=True)

def execute_sql_file(filepath, cursor):
    """
    Reads a SQL file and splits it by the 'GO' keyword.
    pyodbc cannot execute 'GO' directly, so we run the file in smaller batches.
    """
    with open(filepath, 'r') as file:
        sql_script = file.read()
    
    # Use regular expressions to find 'GO' even if it has spaces or different casing
    sql_batches = re.split(r'(?i)^\s*GO\s*$', sql_script, flags=re.MULTILINE)
    
    for batch in sql_batches:
        if batch.strip(): # Skip empty strings
            cursor.execute(batch)

def run_pipeline():
    """
    The main engine of the ETL. It calculates file paths and runs 
    the SQL scripts in the correct Medallion sequence.
    """
    # 1. Establish where we are in the computer's folder structure
    current_dir = os.path.dirname(os.path.abspath(__file__)) # automation folder
    base_repo_path = os.path.dirname(current_dir)            # root folder
    
    # 2. Define where datasets and original scripts live
    datasets_path = os.path.join(base_repo_path, 'datasets')
    original_scripts_dir = os.path.join(base_repo_path, 'scripts')

    # 3. Define the list of files to run in order
    pipeline_steps = [
        {"name": "Init DB & Schemas", "path": os.path.join(original_scripts_dir, "init_database_and_schema_creation.sql")},
        {"name": "Bronze DDL", "path": os.path.join(original_scripts_dir, "bronze", "ddl_bronze.sql")},
        {"name": "Bronze Load Procedure", "path": os.path.join(current_dir, "loading_bronze_data.sql")},
    ]

    try:
        print("🚀 Starting Data Warehouse Pipeline...")
        conn = get_db_connection()
        cursor = conn.cursor()

        # Step A: Run the DDL scripts and create the Stored Procedures
        for step in pipeline_steps:
            print(f"⏳ Executing: {step['name']}")
            execute_sql_file(step["path"], cursor)

        # Step B: Actually trigger the data loading procedure
        print(f"\n📥 Loading Bronze Data from: {datasets_path}")
        # We pass the datasets_path variable into the @BasePath parameter of our SQL procedure
        cursor.execute("EXEC bronze.load_bronze @BasePath = ?", datasets_path)
        
        print("\n✅ Pipeline Executed Successfully!")

    except pyodbc.Error as e:
        print(f"\n❌ Database Error: {e}")
    finally:
        if 'conn' in locals():
            conn.close()
            print("Connection closed.")

if __name__ == "__main__":
    run_pipeline()
