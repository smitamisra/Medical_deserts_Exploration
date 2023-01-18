#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Medical Deserts Identification"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      h3("MAP"),
      h6("Select a state to plot the hospitals on map"),
      selectInput(inputId = "z", 
                  label = "Hospital:",
                  choices = c("All" = "All",
                              "Alabama" = "AL",
                              "Alaska" = "AK",
                              "Arizona" = "AZ",
                              "Arkansas" = "AR",
                              "California" = "CA",
                              "Colorado" = "CO",
                              "Connecticut" = "CT",
                              "Delaware" = "DE",
                              "Florida" = "FL",
                              "Georgia" = "GA",
                              "Hawaii" = "HI",
                              "Idaho" = "ID",
                              "Illinois" = "IL",
                              "Indiana" = "IN",
                              "Iowa" = "IA",
                              "Kansas" = "KS",
                              "Kentucky" = "KY",
                              "Louisiana" = "LA",
                              "Maine" = "ME",
                              "Maryland" = "MD",
                              "Massachusetts" = "MA",
                              "Michigan" = "MI",
                              "Minnesota" = "MN",
                              "Mississippi" = "MS",
                              "Missouri" = "MO",
                              "Montana" = "MT",
                              "Nebraska" = "NE",
                              "Nevada" = "NV",
                              "NewHampshire" = "NH",
                              "NewJersey" = "NJ",
                              "NewMexico" = "NM",
                              "NewYork" = "NY",
                              "NorthCarolina" = "NC",
                              "NorthDakota" = "ND",
                              "Ohio" = "OH",
                              "Oklahoma" = "OK",
                              "Oregon" = "OR",
                              "Pennsylvania" = "PA",
                              "RhodeIsland" = "RI",
                              "SouthCarolina" = "SC",
                              "SouthDakota" = "SD",
                              "Tennessee" = "TN",
                              "Texas" = "TX",
                              "Utah" = "UT",
                              "Vermont" = "VT",
                              "Virginia" = "VA",
                              "Washington" = "WA",
                              "WestVirginia" = "WV",
                              "Wisconsin" = "WI",
                              "Wyoming" = "WY")
      ),
      h6("Select a County"),
      selectInput(inputId = "s", 
                  label = "County:",
                  choices = c("None" = "None",
                              unique(tn_temp1$County))
      ),
      
      h6("Choice option for the Scatter plot:"),
      #select variable for filter with division
      selectInput(inputId = "d", 
                  label = "TN_region:", 
                  choices = c("All" = "All",
                              unique(county_health$Division))
      ),
                  
      #select variable for x-axis
      selectInput(inputId = "e",
                  label = "X-axis:",
                  choices = c("distance to hospital:"= "distance",
                              "Primary Care Physician/100k:" ="PCP_per100K",
                              "Mental Healath Care Physician:" = "MHP_per100K",
                              "Long_alone_commute(Z_score):" = "long_commute_Z_score"),
                  selected = "distance"),
      #select variable for y-axis
      selectInput(inputId = "f",
                  label = "Y-axis:",
                  choices = c("Years of potential life lost:" = "YPLL_per100K",
                              "Rate of preventable hospitalization:" = "Preventable_Hospitalization_per100K",
                              "Injury related death(Z-score)" = "ID_Z_score",
                              "Physically Unhealthy days(Z-score):" = "PUD_Z_score",
                              "Mentally Unhealthy days(Z-score):" = "MUD_Z_score"),
                  selected = "YPLL_per100K"),
      #select variable for color
      selectInput(inputId = "color",
                  label = "Color:",
                  choices = c("Hospital Type:" = "Hospital_type",
                              "Hospital Ownership:" = "Hospital_ownership",
                              "Emergency service available:" = "Emergency Services"),
                  selected = "Hospital_type"),
    ),
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel(strong("Home"),
                 br(),
                 br(),
                 HTML('<div style="font-size:30px">'),
                 HTML("<p><b>Medical desert</b> is a term used to describe regions whose population has inadequate access to healthcare. The term can be applied to general care or specific care. Different socioeconomic and demographic features impact the access to care. The app explores the health and hospital data for the state of Tennessee, USA.</p>"),
                 HTML('<p>In this study, we are using the hospitals general information dataset from <a target="_blank" href="https://data.cms.gov/provider-data">Centers for Medicare & Medicaid Services</a> to locate the hospitals in TN. State health information was collected from the US census bureau, American community survey collection for the year 2021 (https://data.census.gov/table ).</p>'),
                 HTML('</div>')
        ),
        
        tabPanel(strong("Hospital location"),
                 leafletOutput("mymap"),
                 fluidRow(
                   column(width = 6,
                          plotOutput("Hospital_Type")),
                   column(width = 6,
                          plotOutput("Hospital_Ownership"))
                 ),
                 #leafletOutput("mymap")
                 ),
        
        tabPanel(strong("TN County/tract & Hospital"),
                 leafletOutput("map"),
                 fluidRow(
                   column( width = 6,
                          plotOutput("conhos")),
                   column(width = 6,
                          dataTableOutput("table"))
                 ),
                 
        ),
        
        tabPanel(strong("Evaluation County Health"),
                 plotOutput("Dependency"),
                 verbatimTextOutput("lm_summary"),
        )
      )
      
    )
  )
))
