library(data.table)

setwd("C:/Users/User/Desktop/School/Y2S2/BC2407 Analytics II Advanced Predictive Techniques/Project/Team 2")

dt <- fread("Police_Department_Incident_Reports__Historical_2003_to_May_2018.csv", stringsAsFactors = TRUE)

# We can use https://data.sfgov.org/widgets/tmnf-yvry as reference
# We can also use https://www.kaggle.com/san-francisco/sf-master-data-dictionary/version/65 as data dict (Search ")
# Both only indicated 13 columns

relevant.cols <- c("IncidntNum", "Category", "Descript", "DayOfWeek", "Date", "Time",
                   "PdDistrict", "Resolution", "Address", "X", "Y", "Location", "PdId")

relevant.dt <- dt[, relevant.cols, with = FALSE]

# IncidntNum is Case ID
relevant.dt$IncidntNum <- NULL

# PdId is Row Number
relevant.dt$PdId <- NULL

# Location is a combination of X (Longitude) and Y (Latitude)
relevant.dt$Location <- NULL

relevant.dt$Address <- NULL

fwrite(relevant.dt, "All Crimes.csv")










######################################################
##### Optional: Removing Non-Criminal Activities #####
######################################################

dim(relevant.dt[Category == "NON-CRIMINAL"])

# Removing Non-Criminal Activities
relevant.dt <- relevant.dt[Category != "NON-CRIMINAL"]

# Suicide is legal in California: 
# https://www.lacriminaldefenseattorney.com/legal-dictionary/s/suicide/
relevant.dt <- relevant.dt[Category != "SUICIDE"]

# Removing Missing Person Cases
# Note that 'Illegal' missing person cases have been accounted for under "KIDNAPPING"
relevant.dt <- relevant.dt[Category != "MISSING PERSON"]

# Removing Recovered Vehicle Cases
relevant.dt <- relevant.dt[Category != "RECOVERED VEHICLE"]

# Note that Runaway is legal in California:
# https://sites.law.lsu.edu/amicus-curiae/tag/california-runaway-child-laws/
relevant.dt <- relevant.dt[Category != "RUNAWAY"]

# Removing Suspsicious Occ Cases
relevant.dt <- relevant.dt[Category != "SUSPICIOUS OCC"]

relevant.dt <- droplevels(relevant.dt)


# 2. Create new column, Outcome:
#    If Resolution == None, Outcome := Unresolved
#    If Resolution != None, Outcome := Resolved
#
# 3. Create new column, Juvenile:
#    If Resolution contains Juvenile, Juvenile := 1
#    Else, Juvenile := 0
#    By doing this, we can track juvenile crimes