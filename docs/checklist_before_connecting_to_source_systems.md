-- Questions to be asked before we are connecting the source system with the data warehouse system.
/*
# BUSINESS CONTEXT & OWNERSHIP
1. Who owns the data?
2. What business process it supports? Like the customer transactions or supply chain logistics or may be finance reporting
3. System and Data documentation. (It's important to have the documentation as they act as learning materials about your data. This is 
helpful in designing new data models in future)
4. Ask about the data models and data catalog, also if there are any descriptions of the source columns and tables. Helpful while ingesting
data in seamless joining of tables

# ARCHITECTURE & TECHNOLOGY STACK
1. How the data is stored? (SQL Server, Oracle, AWS, Azure, ..etc)
2. What are the integration capabilities, like API, Kafka, File Extract, Direct DB,..etc. (How to get the data from source system?)

# EXTRACT & LOAD
1. Incremental or Full Loads?
2. Data Scope & Historical needs (important when dealing with Slowly Changing Dimensions)
3. Expected size of the extracts? (in MBs/GBs/PBs to make sure we have the correct tools to connect with the source.)
4. Any Data voulume limitations?
5. How to avoid impacting the source system's performance? (Important to make sure that we are not bring down the performance of the DB)
6. Authentication and Authorization. How we are going to access the data in the source system? (tokens, SSH keys, VPN, IP whitelisting etc.)
*/
