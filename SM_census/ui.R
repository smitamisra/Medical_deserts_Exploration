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
                                    "Florida" = "FL",
                                    "Arizona" = "AZ",
                                    "Tennessee" = "TN")
        ),
        h3("Select a County"),
        selectInput(inputId = "s", 
                    label = "County:",
                    choices = c("All" = "All",
                                "Davidson" = "Davidson")
        )
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
                     fluidRow(
                       column(width = 6,
                     plotOutput("Hospital_Type")),
                     column(width = 6,
                     plotOutput("Hospital_Ownership"))
                     ),
                     leafletOutput("mymap")),
            tabPanel(strong("County Health Info"), plotOutput("plot")),
            tabPanel(strong("Table"), tableOutput("table"))
          )
          
        )
        )
))