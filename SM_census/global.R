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

hospital_rds <- readRDS('data/hospital_rds.rds') 
hospital_sf = st_as_sf(hospital_rds, coords = c("lon", "lat"), 
                       crs = 4326)

sf_circles <- readRDS("data/sf_circles.rds") %>%
  filter(State == "TN")  
tn_temp1 <- readRDS("data/tn_temp1.rds")


