c
execute_plp_symptomatic=function(connectionDetails=connectionDetails,
                    cdmDatabaseSchema=cdmDatabaseSchema,
                    vocabularyDatabaseSchema = cdmDatabaseSchema,
                    cohortDatabaseSchema = cohortDatabaseSchema,
                    cohortTable =  cohortTable,
                    GenerateCohorts = TRUE,
                    tempEmulationSchema = getOption("sqlRenderTempEmulationSchema"),
                    outputFolder=outputFolder,
                    incrementalFolder = file.path(outputFolder, "incrementalFolder"),
                    databaseId =   databaseId,
                    packageWithCohortDefinitions = "PioneerPlpMhspc",
                    cohortIds = NULL,
                    databaseName = databaseId,
                    databaseDescription = databaseDescription,
                    extraLog = NULL) 
 {


if(GenerateCohorts==TRUE)
    { 
        cohort_generation(connectionDetails= connectionDetails ,
                    cdmDatabaseSchema = cdmDatabaseSchema,
                    vocabularyDatabaseSchema = cdmDatabaseSchema,
                    cohortDatabaseSchema = cohortDatabaseSchema,
                    cohortTable = cohortTable,
                    tempEmulationSchema = getOption("sqlRenderTempEmulationSchema"),
                    outputFolder= outputFolder,
                    incrementalFolder = file.path(outputFolder, "incrementalFolder"),
                    databaseId = databaseId,
                    packageWithCohortDefinitions = "PioneerPlpMhspc",
                    cohortIds = NULL,
                    minCellCount = 5,
                    databaseName = databaseName,
                    databaseDescription = databaseDescription,
                    extraLog = NULL) 

    }

# Create the PLP database details 
DatabaseDetails=PatientLevelPrediction::createDatabaseDetails (connectionDetails,
                            cdmDatabaseSchema=cdmDatabaseSchema, 
                            cdmDatabaseName=databaseName, 
                            cdmDatabaseId= databaseId,
                            tempEmulationSchema = cdmDatabaseSchema,
                            cohortDatabaseSchema = cohortDatabaseSchema, 
                            cohortTable = cohortTable,
                            outcomeDatabaseSchema = cohortDatabaseSchema, 
                            outcomeTable = cohortTable )

# The first step is to select the variables that will be used in the model:
# this is done by creating a covariate setting object using the createCovariateSettings
# function from the FeatureExtraction package.

#Covariate setting 1: 

# Without index information
covSet<-FeatureExtraction::createCovariateSettings(
    	useDemographicsGender = TRUE, 
			useDemographicsAge = TRUE,
			useDemographicsAgeGroup = TRUE, 
			useDemographicsRace = TRUE,
			useDemographicsEthnicity = TRUE, 
			useDemographicsIndexYear = FALSE,
			useDemographicsIndexMonth = FALSE,
			useDemographicsPriorObservationTime = TRUE,
			useDemographicsPostObservationTime = FALSE,
			useDemographicsTimeInCohort = FALSE,
			useDemographicsIndexYearMonth = FALSE,
			useConditionOccurrenceAnyTimePrior = TRUE,
			useConditionOccurrenceLongTerm = TRUE,
			useConditionOccurrenceMediumTerm = TRUE,
			useConditionOccurrenceShortTerm = TRUE,
			useConditionOccurrencePrimaryInpatientAnyTimePrior = TRUE,
			useConditionOccurrencePrimaryInpatientLongTerm = TRUE, 
			useConditionOccurrencePrimaryInpatientMediumTerm = TRUE,
			useConditionOccurrencePrimaryInpatientShortTerm = TRUE,
			useConditionEraAnyTimePrior = TRUE,
			useConditionEraLongTerm = TRUE,
			useConditionEraMediumTerm = TRUE,
			useConditionEraShortTerm = TRUE,
			useConditionEraOverlapping = TRUE,
			useConditionEraStartLongTerm = TRUE,
			useConditionEraStartMediumTerm = TRUE,
			useConditionEraStartShortTerm = TRUE,
			useConditionGroupEraAnyTimePrior = TRUE, 
			useConditionGroupEraLongTerm = TRUE,
			useConditionGroupEraMediumTerm = TRUE,
			useConditionGroupEraShortTerm = TRUE,
			useConditionGroupEraOverlapping = TRUE,
			useConditionGroupEraStartLongTerm = TRUE,
			useConditionGroupEraStartMediumTerm = TRUE,
			useConditionGroupEraStartShortTerm = TRUE,
			useDrugExposureAnyTimePrior = TRUE,
			useDrugExposureLongTerm = TRUE,
			useDrugExposureMediumTerm = TRUE, 
			useDrugExposureShortTerm = TRUE,
			useDrugEraAnyTimePrior = TRUE, 
			useDrugEraLongTerm = TRUE,
			useDrugEraMediumTerm = TRUE,
			useDrugEraShortTerm = TRUE,
			useDrugEraOverlapping = TRUE,
			useDrugEraStartLongTerm = TRUE,
			useDrugEraStartMediumTerm = TRUE,
			useDrugEraStartShortTerm = TRUE,
			useDrugGroupEraAnyTimePrior = TRUE,
			useDrugGroupEraLongTerm = TRUE,
			useDrugGroupEraMediumTerm = TRUE, 
			useDrugGroupEraShortTerm = TRUE,
			useDrugGroupEraOverlapping = TRUE,
			useDrugGroupEraStartLongTerm = TRUE,
			useDrugGroupEraStartMediumTerm = TRUE,
			useDrugGroupEraStartShortTerm = TRUE,
			useProcedureOccurrenceAnyTimePrior = TRUE,
			useProcedureOccurrenceLongTerm = TRUE,
			useProcedureOccurrenceMediumTerm = TRUE,
			useProcedureOccurrenceShortTerm = TRUE,
			useDeviceExposureAnyTimePrior = TRUE, 
			useDeviceExposureLongTerm = TRUE,
			useDeviceExposureMediumTerm = TRUE,
			useDeviceExposureShortTerm = TRUE,
			useMeasurementAnyTimePrior = TRUE, 
			useMeasurementLongTerm = TRUE,
			useMeasurementMediumTerm = TRUE,
			useMeasurementShortTerm = TRUE,
			useMeasurementValueAnyTimePrior = TRUE,
			useMeasurementValueLongTerm = TRUE,
			useMeasurementValueMediumTerm = TRUE,
			useMeasurementValueShortTerm = TRUE,
			useMeasurementRangeGroupAnyTimePrior = TRUE,
			useMeasurementRangeGroupLongTerm = TRUE,
			useMeasurementRangeGroupMediumTerm = TRUE, 
			useMeasurementRangeGroupShortTerm = TRUE,
			useObservationAnyTimePrior = TRUE,
			useObservationLongTerm = TRUE,
			useObservationMediumTerm = TRUE,
			useObservationShortTerm = TRUE,
			useCharlsonIndex = TRUE,
			useDcsi = TRUE,
			useChads2 = TRUE,
			useChads2Vasc = TRUE,
			useHfrs = TRUE,
			useDistinctConditionCountLongTerm = TRUE,
			useDistinctConditionCountMediumTerm = TRUE, 
			useDistinctConditionCountShortTerm = TRUE,
			useDistinctIngredientCountLongTerm = TRUE, 
			useDistinctIngredientCountMediumTerm = TRUE,
			useDistinctIngredientCountShortTerm = TRUE, 
			useDistinctProcedureCountLongTerm = TRUE,
			useDistinctProcedureCountMediumTerm = TRUE,
			useDistinctProcedureCountShortTerm = TRUE,
			useDistinctMeasurementCountLongTerm = TRUE,
			useDistinctMeasurementCountMediumTerm = TRUE,
			useDistinctMeasurementCountShortTerm = TRUE, 
			useDistinctObservationCountLongTerm = TRUE,
			useDistinctObservationCountMediumTerm = TRUE,
			useDistinctObservationCountShortTerm = TRUE,
			useVisitCountLongTerm = TRUE, 
			useVisitCountMediumTerm = TRUE,
			useVisitCountShortTerm = TRUE,
			useVisitConceptCountLongTerm = TRUE,
			useVisitConceptCountMediumTerm = TRUE,
			useVisitConceptCountShortTerm = TRUE,
			longTermStartDays = -365,
			mediumTermStartDays = -180,
			shortTermStartDays = -30,
			endDays = 0, 
			includedCovariateConceptIds = c(),
			addDescendantsToInclude = TRUE,
			excludedCovariateConceptIds = c(),
			addDescendantsToExclude = TRUE,
 ) 
 

#population settings:
popsetting1 <- PatientLevelPrediction::createStudyPopulationSettings(
  washoutPeriod = 0,
  firstExposureOnly = FALSE,
  removeSubjectsWithPriorOutcome = FALSE,
  priorOutcomeLookback = 1,
  riskWindowStart = 1,
  riskWindowEnd = 365.25*1,
  startAnchor =  'cohort start',
  endAnchor =  'cohort start',
  minTimeAtRisk = 180,
  requireTimeAtRisk = FALSE,
  includeAllOutcomes = TRUE
)

popsetting2=PatientLevelPrediction::createStudyPopulationSettings(
  washoutPeriod = 0,
  firstExposureOnly = FALSE,
  removeSubjectsWithPriorOutcome = FALSE,
  priorOutcomeLookback = 1,
  riskWindowStart = 1,
  riskWindowEnd = 365.25*3,
  startAnchor =  'cohort start',
  endAnchor =  'cohort start',
  minTimeAtRisk = 180,
  requireTimeAtRisk = FALSE,
  includeAllOutcomes = TRUE
)

popsetting3=PatientLevelPrediction::createStudyPopulationSettings(
  washoutPeriod = 0,
  firstExposureOnly = FALSE,
  removeSubjectsWithPriorOutcome = FALSE,
  priorOutcomeLookback = 1,
  riskWindowStart = 1,
  riskWindowEnd = 365.25*5,
  startAnchor =  'cohort start',
  endAnchor =  'cohort start',
  minTimeAtRisk = 180,
  requireTimeAtRisk = FALSE,
  includeAllOutcomes = TRUE
)

#split settings  
splitSettings <-  PatientLevelPrediction::createDefaultSplitSetting(
trainFraction = 0.75,
testFraction = 0.25,
type = 'stratified',
nfold = 3,
splitSeed = 3121
)

# preprocess settings
preprocessSettings <- PatientLevelPrediction::createPreprocessSettings(
  minFraction = 0.001,
  normalize = T,
  removeRedundancy = T
)

# first model design #using AdaBoost
model1=PatientLevelPrediction::createModelDesign(
    targetId  =360,
    outcomeId = 453, 
    restrictPlpDataSettings = PatientLevelPrediction::createRestrictPlpDataSettings(),   
    populationSettings = popsetting1,
    covariateSettings =  covSet, 
    featureEngineeringSettings = NULL,
    sampleSettings = NULL, 
    preprocessSettings = preprocessSettings,
    modelSettings = PatientLevelPrediction::setAdaBoost(), 
    splitSettings = splitSettings)

model2=PatientLevelPrediction::createModelDesign(
    targetId  =360,
    outcomeId = 453, 
    restrictPlpDataSettings = PatientLevelPrediction::createRestrictPlpDataSettings(), 
    populationSettings = popsetting2,
    covariateSettings =  covSet, 
    featureEngineeringSettings = NULL,
    sampleSettings = NULL, 
    preprocessSettings = preprocessSettings,
    modelSettings = PatientLevelPrediction::setAdaBoost(), 
    splitSettings = splitSettings)  

model3=PatientLevelPrediction::createModelDesign(
    targetId  =360,
    outcomeId = 453, 
    restrictPlpDataSettings = PatientLevelPrediction::createRestrictPlpDataSettings(), 
    populationSettings = popsetting3,
    covariateSettings =  covSet, 
    featureEngineeringSettings = NULL,
    sampleSettings = NULL, 
    preprocessSettings = preprocessSettings,
    modelSettings = PatientLevelPrediction::setAdaBoost(), 
    splitSettings = splitSettings)  

# second model design #using lasso logistic regression
model4=PatientLevelPrediction::createModelDesign(
    targetId  =360,
    outcomeId = 453, 
    restrictPlpDataSettings = PatientLevelPrediction::createRestrictPlpDataSettings(), 
    populationSettings = popsetting1,
    covariateSettings =  covSet, 
    featureEngineeringSettings = NULL,
    sampleSettings = NULL, 
    preprocessSettings = preprocessSettings,
    modelSettings = PatientLevelPrediction::setLassoLogisticRegression(), 
    splitSettings = splitSettings)

model5=PatientLevelPrediction::createModelDesign(
    targetId  =360,
    outcomeId = 453, 
    restrictPlpDataSettings = PatientLevelPrediction::createRestrictPlpDataSettings(), 
    populationSettings = popsetting2,
    covariateSettings =  covSet, 
    featureEngineeringSettings = NULL,
    sampleSettings = NULL, 
    preprocessSettings = preprocessSettings,
    modelSettings = PatientLevelPrediction::setLassoLogisticRegression(), 
    splitSettings = splitSettings)

model6=PatientLevelPrediction::createModelDesign(
    targetId  =360,
    outcomeId = 453, 
    restrictPlpDataSettings = PatientLevelPrediction::createRestrictPlpDataSettings(), 
    populationSettings = popsetting3,
    covariateSettings =  covSet, 
    featureEngineeringSettings = NULL,
    sampleSettings = NULL, 
    preprocessSettings = preprocessSettings,
    modelSettings = PatientLevelPrediction::setLassoLogisticRegression(), 
    splitSettings = splitSettings)
# Third model design using cox proportional hazard model

model7=PatientLevelPrediction::createModelDesign(
    targetId  =360,
    outcomeId = 453, 
    restrictPlpDataSettings = PatientLevelPrediction::createRestrictPlpDataSettings(), 
    populationSettings = popsetting1,
    covariateSettings =  covSet, 
    featureEngineeringSettings = NULL,
    sampleSettings = NULL, 
    preprocessSettings = preprocessSettings,
    modelSettings = PatientLevelPrediction::setCoxModel(), 
    splitSettings = splitSettings)

model8=PatientLevelPrediction::createModelDesign(
    targetId  =360,
    outcomeId = 453, 
    restrictPlpDataSettings = PatientLevelPrediction::createRestrictPlpDataSettings(), 
    populationSettings = popsetting2,
    covariateSettings =  covSet, 
    featureEngineeringSettings = NULL,
    sampleSettings = NULL, 
    preprocessSettings = preprocessSettings,
    modelSettings = PatientLevelPrediction::setCoxModel(), 
    splitSettings = splitSettings)

model9=PatientLevelPrediction::createModelDesign(
    targetId  =360,
    outcomeId = 453, 
    restrictPlpDataSettings = PatientLevelPrediction::createRestrictPlpDataSettings(), 
    populationSettings = popsetting3,
    covariateSettings =  covSet, 
    featureEngineeringSettings = NULL,
    sampleSettings = NULL, 
    preprocessSettings = preprocessSettings,
    modelSettings = PatientLevelPrediction::setCoxModel(), 
    splitSettings = splitSettings)

#run the models
PatientLevelPrediction::runMultiplePlp (databaseDetails =DatabaseDetails  ,
 modelDesignList = list(model1,model2,model3,model4,model5,model6,model7,model8,model9),
  saveDirectory =  outputFolder, 
    sqliteLocation = file.path(outputFolder, "sqlite"))  
 }
