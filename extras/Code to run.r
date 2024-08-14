library(PioneerPlpMhspc)

# The folder where the study intermediate and result files will be written:
outputFolder <- "C:/...."

 
# Details for connecting to the server:
DBMS= "postgresql" # Database management system name; has to be one of the following:
#'sql server','oracle','postgresql','pdw','impala','netezza','bigquery','spark','sqlite','redshift','hive','sqlite extended','duckdb','snowflake','synapse'

 USER = "johnsmith" #user name for connecting to the server
 PASSWORD= "john1234"#password for connecting to the server
 SERVER = "localhost/postgres" #server name
 DB_PORT = 5432 #port number
 pathToDriver='C:/JDBC' #path to the folder where the JDBC driver is stored

#############################################################################
# Creae connection details
connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = DBMS,
                                                                user = USER,
                                                                password = PASSWORD,
                                                                server = SERVER,
                                                                port = DB_PORT,
                                                                pathToDriver = pathToDriver)

#############################################################################
# Schema details
cdmDatabaseSchema <- "CDM_IBM_MDCD_V1153.dbo"  # The name of the database schema where the CDM data can be found:
cohortDatabaseSchema <- "sandbox"          # The name of the database schema and table where the study-specific cohorts will be instantiated:
cohortTable <- "cohort"           # Table in the cohortDatabaseSchema where the cohorts will be instantiated

#############################################################################
# Some meta-information that will be used by the export function:
databaseId <- "Synpuf"  # A short string for identifying the database (e.g. 'synpuf').
databaseName <- "Medicare Claims Synthetic Public Use Files (SynPUFs)" # The full name of the database (e.g. 'Medicare Claims Synthetic Public Use Files (SynPUFs)').
databaseDescription <-  "Medicare Claims Synthetic Public Use Files (SynPUFs) were created to allow interested parties to gain familiarity using Medicare claims data while protecting beneficiary privacy. These files are intended to promote development of software and applications that utilize files in this format, train researchers on the use and complexities of Centers for Medicare and Medicaid Services (CMS) claims, and support safe data mining innovations. The SynPUFs were created by combining randomized information from multiple unique beneficiaries and changing variable values. This randomization and combining of beneficiary information ensures privacy of health information."

# For some database platforms (e.g. Oracle): define a schema that can be used to emulate temp tables:
options(sqlRenderTempEmulationSchema = NULL)


#############################################################################
#############################################################################

# Execute the Plp study to predict symptomatic progression

PioneerPlpMhspc::execute_plp_symptomatic(
  connectionDetails = connectionDetails,
  cdmDatabaseSchema = cdmDatabaseSchema,
  cohortDatabaseSchema = cohortDatabaseSchema,
  cohortTable = cohortTable,
  outputFolder = outputFolder,
  databaseId = databaseId,
  databaseName = databaseName,
  databaseDescription = databaseDescription
)


# # Execute the Plp study to predict death

# # ONLY RUN THIS IF YOU KNOW YOUR DATABASE HAS DEATH RECORDS

# Specify the output folder:
outputFolderdeath="C:/...."

PioneerPlpMhspc::execute_plp_death(
  connectionDetails = connectionDetails,
  cdmDatabaseSchema = cdmDatabaseSchema,
  cohortDatabaseSchema = cohortDatabaseSchema,
  cohortTable = cohortTable,
  outputFolder = outputFolderdeath,
  databaseId = databaseId,
  databaseName = databaseName,
  databaseDescription = databaseDescription
)

