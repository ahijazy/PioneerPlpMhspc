library(ROhdsiWebApi)

baseUrl <-"https://pioneer.hzdr.de/WebAPI"

token <- 'Bearer ....'
setAuthHeader(baseUrl = baseUrl, token)

# after inserting the cohorts
 
# Insert cohort definitions from ATLAS into package -----------------------
ROhdsiWebApi::insertCohortDefinitionSetInPackage(fileName = "inst/settings/CohortsToCreate.csv",
baseUrl = baseUrl ,
insertTableSql = TRUE,
insertCohortCreationR = TRUE,
generateStats = FALSE,
packageName = "PioneerPlpMhspc")
