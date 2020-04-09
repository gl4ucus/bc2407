library(data.table)

setwd("C:/Users/User/Desktop/School/Y2S2/BC2407 Analytics II Advanced Predictive Techniques/Project/Team 2")


####### Reducing Data Size By Removing Redundant & Meaningless Rows #######
# We can use https://data.sfgov.org/widgets/tmnf-yvry as reference
# We can also use https://www.kaggle.com/san-francisco/sf-master-data-dictionary/version/65 as data dict (Search ")
# Both only indicated 13 columns

#dt <- fread("Police_Department_Incident_Reports__Historical_2003_to_May_2018.csv", stringsAsFactors = TRUE)
## Now is 529MB

#relevant.cols <- c("IncidntNum", "Category", "Descript", "DayOfWeek", "Date", "Time",
#                   "PdDistrict", "Resolution", "Address", "X", "Y", "Location", "PdId")

#relevant.dt <- dt[, relevant.cols, with = FALSE]

#fwrite(relevant.dt, "Relevant Data.csv")

## Now is 441MB
#######

####### Further Reducing Data Size  #######
#colnames(relevant.dt)

#relevant.dt$IncidntNum <- NULL

##PdId is row number
#relevant.dt$PdId <- NULL

##Location is a combination of X - Longitude and Y - Latitude
#relevant.dt$Location <- NULL

#fwrite(relevant.dt, "Relevant Data (small).csv")
## Now is 299MB

#relevant.dt$Address <- NULL
#relevant.dt$X <- NULL
#relevant.dt$Y <- NULL
#fwrite(relevant.dt, "Relevant Data (smaller).csv")
## Now is 176MB

### Potential Areas to Cut / Improve
# 1. Remove rows that are "NON-CRIMINAL" / "SUICIDE" / "MISSING PERSON" under Category
# Note: Suicide is not illegal in California: https://www.lacriminaldefenseattorney.com/legal-dictionary/s/suicide/
# Note: No need worry about missing person, still got Kidnapping under Category
#
# 2. Create new column, Outcome:
#    If Resolution == None, Outcome := Unresolved
#    If Resolution != None, Outcome := Resolved
#
# 3. Create new column, Juvenile:
#    If Resolution contains Juvenile, Juvenile := 1
#    Else, Juvenile := 0
#    By doing this, we can track juvenile crimes
