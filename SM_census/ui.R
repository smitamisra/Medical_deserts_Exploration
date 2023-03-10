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
  titlePanel(
    h2("Medical Deserts:")
  ),
  titlePanel(
    h3("Exploring access to healthcare and its potential impact on health outcome")
  ),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      h5("Selection for Hospital_info Tab"),
      h6("Select a state to plot the hospitals on map"),
      selectInput(inputId = "z", 
                  label = "State:",
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
                              "Wyoming" = "WY",
                              "AmericanSamoa" = "AS",
                              "Guam" = "GU",
                              "NorthernMarinaIsland"="MP")
      ),
      h5("Selection for TN:County:Tract Tab"),
      h6("Select a County"),
      selectInput(inputId = "s", 
                  label = "County:",
                  choices = c("None" = "None",
                              unique(tn_temp1$County)),
                  selected = ("Davidson")
      ),
      
      h5("County Health Analysis depending upon acess to care"),
      h6("Choice options for the linear model:"),
      #select variable for filter with division
      selectInput(inputId = "d", 
                  label = "TN_region:", 
                  choices = c("All" = "All",
                              unique(county_health$Division))
      ),
      
      #select variable for x-axis
      h6("Choose a Predictor/Explanatory Variable:"),
      selectInput(inputId = "e",
                  label = "Predictor:",
                  choices = c("Distance to nearest hospital:"= "distance",
                              "Primary Care Physician/100k:" ="PCP_per100K",
                              "Mental Healath Care Physician/100k:" = "MHP_per100K",
                              "Long Commute(Z-score):" = "long_commute_Z_score",
                              "Socioeconomic factors(Z-Score)"= "Socioeconomic_factors",
                              "Physical Environment(Z-Score)" = "Physical_Environment",
                              "Length of Life(Z-Score)" = "Length_of_Life",	
                              "Qyuality of life(Z-Score)"	= "Qyuality_of_life",
                              "Health Behaviors(Z-Score)" = "Health_Behaviors",
                              "Clinical Care(Z-Score)"	= "Clinical_Care"),
                  selected = "distance"),
      #select variable for y-axis
      h6("Choose a Response/Outcome Variable:"),
      selectInput(inputId = "f",
                  label = "Outcome:",
                  choices = c("Years of potential life lost:" = "YPLL_per100K",
                              "Clinical Care(Z-Score)"	= "Clinical_Care",
                              "Length of Life(Z-Score)" = "Length_of_Life",	
                              "Qyuality of life(Z-Score)"	= "Qyuality_of_life",
                              "Health Behaviors(Z-Score)" = "Health_Behaviors",
                              #"Clinical Care(Z-Score)"	= "Clinical_Care",
                              "Rate of preventable hospitalization:" = "Preventable_Hospitalization_per100K",
                              "Injury related death(Z-score)" = "ID_Z_score",
                              "Physically Unhealthy days(Z-score):" = "PUD_Z_score",
                              "Mentally Unhealthy days(Z-score):" = "MUD_Z_score"),
                  selected = "YPLL_per100K"),
      #select variable for color
      h6("Choose  for visualization of data point color_coded:"),
      selectInput(inputId = "color",
                  label = "Color:",
                  choices = c("TN_region:" = "Division",
                              "Hospital Type:" = "Hospital_type",
                              "Hospital Ownership:" = "Hospital_ownership",
                              "Emergency service available:" = "Emergency Services"),
                  selected = "Division"),
    ),
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel(strong("Home"),
                 br(),
                 
                 HTML('<div style="font-size:12px">'),
                 HTML("<p><b>Medical desert</b> is a term used to describe regions whose population has inadequate access to healthcare. The term can be applied to general care or specific care. Different socioeconomic and demographic features impact the access to care. The app explores the health and hospital data for the state of Tennessee (TN), USA.</p>"),
                 HTML('<p>In this study, we are using the hospitals general information dataset from <a target="_blank" href="https://data.cms.gov/provider-data">Centers for Medicare & Medicaid Services</a>. Five year Tract and County level population and health matrix were gathered from the <a target="_blank" href="https://data.census.gov/table">US Census Bureau</a>, American community survey collection for the year 2021.</p>'),
                 HTML("<p>There are a total of 5299 hospitals across US 50 states. Census data is collected at State/County/tract level. In total US has 3143 counties,84,414 census tract. State of TN has three regions, 96 counties and 1701 tract. Avalability and access to resources for health care impact the overall health outcome. In this app we using different predictor varibales including prooximity(distance) to the nearest facility, which is calcuated using the census county/tract level shape file and google-maps-api.</p>"),
                 
                 HTML('</div>'),
                 
                 plotlyOutput("ushos")
        ),
        
        tabPanel(strong("Hospital_Info"),
                 leafletOutput("mymap"),
                 br(),
                 fluidRow(
                   column(width = 6,
                          plotOutput("Hospital_Type")),
                   column(width = 6,
                          plotOutput("Hospital_Ownership"))
                 ),
                 #leafletOutput("mymap")
        ),
        
        tabPanel(strong("TN:County:tract_Hospital"),
                 br(),
                 leafletOutput("map"),
                 fluidRow(
                   column( width = 6,
                           plotOutput("conhos")),
                   column(width = 6,
                          dataTableOutput("table"))
                 ),
                 
        ),
        
        tabPanel(strong("Evaluation County Health"),
                 fluidRow(
                   column(width = 3,
                          plotlyOutput("plot_x")),
                   column(width = 3,
                          plotlyOutput("plot_y")),
                   
                   column(width = 6,
                          plotOutput("Dependency"))
                 ),
                 br(),
                 
                 verbatimTextOutput("lm_summary"),
        ),
        tabPanel(strong("Data_dictionary"),
                 br(),
                 
                 HTML('<div style="font-size:14px">'),
                 
                 HTML("<p><b>Years of Potential Life lost(YPLL):</b>is an estimate of the average years a person would have lived if they had not died prematurely. It is, therefore, a measure of premature mortality.</p>"),
                 HTML("<p><b>Rate</b>is used when values are reported per 100000 units</p>"),
                 HTML("<p><b>Z-Score</b>are calculated using the following equation <b>(Measure - Average of state counties)/(Standard Deviation)</b></p>"),
                 
                 HTML("<p><b>HEALTH OUTCOME:</b> measure Length and quality of life</p>"),
                 HTML("<p><b>HEALTH BEHAVIORS: </b>  Tobacco Use, Diet & Exercise, Alcohol & Drug Use, Sexual Activity</p>"),
                 
                 HTML("<p><b>CLINICAL CARE: </b>  Access to care and Quality of care</p>"),
                 
                 HTML("<p><b>SOCIOECONOMIC FACTORS: </b>  Education, Employment, Income, Family & Social Support, Community Support</p>"),
                 
                 HTML("<p><b>PHYSICA ENVIRONMENT: </b>  Air and water quality, Housing and Transit</p>"),
                 
                 
                 HTML("<p><b>Physically Unhealthy days(PUD)</b> are reported per month</p>"),
                 HTML("<p><b>Mentally Unheathy Days (MUD)</b> are reported per month</p>"),
                 HTML("<p>PCP is for Primary Care Physician</p>"),
                 HTML("<p>MHP is for mental health provider</p>"),
                 HTML("<p>American Indian and Alaskan Native race are abbreviated as AIAN or AI_AN</p>"),
                 HTML("<p>Pacifi Islander and Native Hawaiian race are abbreviated as PINH or PI_NH</p>"),
                 HTML('</div>'),
                 br(),
                 # p((strong(span("YPLL", style = "color : blue"))),
                 #   "::Years of Potential Life Lost Rate"),
                 # p((strong(span("YPLL_100K", style = "color : blue"))), 
                 #   "::Age-adjusted YPLL rate per 100,000"),
                 # p((strong(span("PUD", style = "color : blue"))), 
                 #   ":: Physically Unhealthy Days"),
                 # p((strong(span("MUD", style = "color : blue"))),
                 #   ":: Mentaly Unhealthy Days"),
                 # p((strong(span("PCP", style = "color : blue"))),
                 #   ":: Primary Care Physician"),
                 # p((strong(span("MHP", style = "color : blue"))), 
                 #   ":: Mental Healthcare Provider"),
                 # p((strong(span("ID", style = "color : blue"))), 
                 #   ":: Injury related death"),
                 # p((strong(span("AI_AN or AIAN", style = "color : blue"))),
                 #   ":: American Indian / Alaskan Native"),
                 # p((strong(span("PI_NH or PINH", style = "color : blue"))),
                 #   ":: Pacific Indian Native Hawaiian"),
                 
                 HTML('<div style="font-size:14px">'),
                 
                 HTML("<p><b>US-States and Territory 2 letter code:</b></p>"),
                 HTML("<p>Alabama = AL,   Alaska = AK,   American Samoa = AS, Arizona = AZ,   Arkansas = AR,   California = CA,   Colorado = CO,   Connecticut = CT,   Delaware = DE,   Florida = FL,   Georgia = GA, Guam =GU, Hawaii = HI,   Idaho = ID,   Illinois = IL,   Indiana = IN,   Iowa = IA,   Kansas = KS,   Kentucky = KY,   Louisiana = LA,   Maine = ME,   Maryland = MD,   Massachusetts = MA,   Michigan = MI,   Minnesota = MN,   Mississippi = MS,   Missouri = MO,   Montana = MT,  North Marina Island =MP, Nebraska = NE,   Nevada = NV,   NewHampshire = NH,   NewJersey = NJ,   NewMexico = NM,   NewYork = NY,   NorthCarolina = NC,   NorthDakota = ND,   Ohio = OH,   Oklahoma = OK,   Oregon = OR,   Pennsylvania = PA,   RhodeIsland = RI,   SouthCarolina = SC,   SouthDakota = SD,   Tennessee = TN,   Texas = TX,   Utah = UT,   Vermont = VT,   Virginia = VA,   Washington = WA,   WestVirginia = WV,   Wisconsin = WI,   Wyoming = WY </P>"),
                 
                 HTML('</div>'),
                 br()
        )
        
      )
      
    )
  )
))
