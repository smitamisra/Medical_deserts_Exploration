library(shiny)
library(plotly)
library(readxl)
library(DT)

library(tidyverse)
library(ggplot2)
library(dplyr)
library(readr)
library(tibble)
library(ggmap)
library(sf)
library(leaflet)
library(htmltools)
library(scales)
library(units)

hospital_rds <- readRDS('data/hospital_rds.rds') 
hospital_sf = st_as_sf(hospital_rds, coords = c("lon", "lat"), 
                       crs = 4326)

sf_circles <- readRDS("data/sf_circles.rds") %>%
  filter(State == "TN")  
tn_temp1 <- readRDS("data/tn_temp1.rds")

tn_temp1 <- tn_temp1%>%
  mutate(distance = round(distance, 3))

#county_health <-readRDS("data/county_helath.rds")

county_health <-readRDS("data/county_health_mod.rds")


# labels <- c(
#   "Physically_Unhealthy_Days(PUD)_AvgNo" = "Physically Unhealth Days (Avg No)",
#   "YPLL_per100K" = "Years of Potential Life Lost Rate"
# )

labels <- c(
  #creating labels for the plots in tab 3
  #colnames(county_health)
  "County" = "County",
  "Total_Population" = "Total Population Count",
  "Race_White" = "White Population Count",
  "Race_Black" = "Black Population Count",
  "Race_AIAN" = "AIAN Population Count",
  "Race_Asian" = "Asian Population Count",
  "Race_PINH" = "PINH Population Count",
  "Facility ID" = "Hospital CMS ID#",
  "Facility Name" = "Hospital Name",
  "Address" = "Hospital street Address",
  "City"   = "Hospital City",
  "State...5" = "Hospital State",
  "ZIP Code"  = "Hospital Zipcode",
  "comp_address" = "Hospital Address",
  "County Name"  = "Hospital County",
  "Phone Number" = "Hospital Phone#",
  "Hospital_type" = "Facility Type",
  "Hospital_ownership" = "Hospital Ownership",
  "Emergency Services" = "Availability of Emergency Servie",
  "deaths<75_totalNo" = "Deaths",
  "YPLL_per100K"     = "Years of Potential Life Lost Rate",
  "YPLL_Z_score"  =   "Years of Potential Life Lost (Z-score)",
  "AIAN_YPLL_ per100K" = "AIAN Years of Potential Life Lost (Z-score)",
  "Asian_YPLL_ per100K" = "Asian Years of Potential Life Lost (Z-score)",
  "Black_YPLL_ per100K"   = "Black Years of Potential Life Lost (Z-score)",
  "Hispanic_YPLL_ per100K"= "Hispanic Years of Potential Life Lost (Z-score)",
  "White_YPLL_ per100K"   = "White Years of Potential Life Lost (Z-score)" ,
  "Physically_Unhealthy_Days(PUD)_AvgNo" = "Physically Unhealthy Days (mean)" ,
  "PUD_Z_score"                 = "Physically Unhealthy Days (Z-score)",
  "Mentally_Unhealthy_Days(MUD)_AvgNo" = "Mentally Unhealthy Days (mean)" ,
  "MUD_Z_score"                      = "Physically Unhealthy Days (Z-score)",
  "Driving_Deaths_totalNo."    = "Deaths (Driving)",
  "PCP_totalNo"                = "Primary Care Physician (Count)" ,
  "PCP_per100K"            =    "Primary Care Physician Rate" ,
  "People/PCP_ratio"   =    "Primary Care Physician:Population (Ratio)" ,
  "PCP_Z_score"        ="Primary Care Physician (Z-score)" ,
  "MHP_totalNo"           = "Mental Health Provider (Count)",
  "MHP_per100K"           = "Mental Health Provider (Rate)"  ,
  "NumberPeople/MHP_ration"   = "Mental Health Physician:People (Ratio)" ,
  "MHP_Z_score"                = "Mental Health Physician (Z-score)" ,
  "Preventable_Hospitalization_per100K" = "Preventable Hospitalization (Rate)",
  "Preventable_Hspitalization_Z_score" = "Preventable Hospitalization (Z-score)" ,
  "InjuryDeaths(ID)_totalNo" = "Total Death Count (Injury)",
  "ID_per_100K"        = "Total Death Rate (Injury)",
  "ID_Z_score"           = "Death Z-score (Injury)" ,
  "AIAN_ID_per_100K"   =  "AIAN Death Rate (Injury)" ,
  "Asian_ID_per_100K"   ="Asian Death Rate (Injury)" ,
  "Black_ID_per_100K"    ="Black Death Rate (Injury)",
  "Hispanic_ ID_per_100K" ="Hispanic Death Rate (Injury)",
  "White_ ID_per_100K" =  "White Death Rate (Injury)" ,
  "Percent_long_commute" = "Commute:Long(%)"           ,
  "long_commute_Z_score"= "Commute:Long(Z-score)"       ,
  "distance"  = "Distance from Nearest Hospital (Miles)",
  "Household_Income" = "Household Income (Mean)"         ,
  "Family_Income" = "Family Income (Mean)"                ,
  "Yes_vehicle"  = "Number of People Own_Vehicle (Yes)"    ,
  "No_Vehicle"   = "Number of People Own_Vehicle (No)"      ,
  "Yes_insurance" = "Number of People With_Insurance"        ,
  "distance_tohos" = "Distance to hospital(Tract Sum)"        ,
  "Total_pop" = "Total Population (Tract sum)"
  )

