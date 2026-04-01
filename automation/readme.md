# 🚀 SQL Data Warehouse Automation Pipeline

An automated ETL pipeline that initializes a Microsoft SQL Server Data Warehouse and loads CSV data into the **Bronze** layer using Python and dynamic SQL.

---

## 📌 Overview

This project automates the process of:

- Creating the required database and schema objects.
- Loading raw CSV files into the Bronze layer.
- Using Python to connect to SQL Server securely.
- Running dynamic bulk data ingestion through a stored procedure.

---

## 📁 Project Structure

```bash
automation/
├── run_pipeline.py              # Main Python script to run the ETL pipeline
├── loading_bronze_data.sql      # Stored procedure for dynamic data loading
└── .env.example                 # Sample environment variable file

datasets/                        # Source CSV files
scripts/                         # DDL and schema setup scripts
```

**🛠️ Prerequisites**
Before running the project, make sure you have the following installed:

Microsoft SQL Server (local instance or development server)

Python 3.x

Microsoft ODBC Driver 17 for SQL Server

**📦 Installation**
Install the required Python packages:

```bash
pip install pyodbc python-dotenv
```
**⚙️ Configuration:**
This project uses environment variables to keep server details secure.

**Steps:**
Go to the automation/ folder.
Copy .env.example and rename it to .env.
Update the .env file with your SQL Server details.

**Example:**
SQL_SERVER=Your_Server_Name_Here
SQL_DATABASE=DataWarehouse

**▶️ How to Run**
After configuring the environment variables, run the pipeline from the root of the repository:

```code snippet
python automation/run_pipeline.py
```

**🔄 How It Works**
Python uses pyodbc and python-dotenv to connect securely to your SQL Server instance.

**Database Initialization**
The script runs the database and schema creation scripts such as init_database_and_schema_creation.sql and ddl_bronze.sql.

**Dynamic Path Handling**
Python determines the absolute path of the datasets/ folder and passes it to the SQL stored procedure.

**Data Loading**
The stored procedure uses BULK INSERT to load CSV files into the Bronze tables automatically.

**✅ Expected Result**
After successful execution, the CSV files from the datasets/ folder will be loaded into the Bronze layer of your SQL Data Warehouse.

**📎 Notes**
Ensure the SQL Server service is running before executing the pipeline.
Verify the .env file values carefully before running.
Make sure the ODBC driver is installed correctly.

-----
**Drafted this script using Google Gemini. I’d appreciate a close look at the logic and I'm ready to make any necessary corrections and learn from the process.**
