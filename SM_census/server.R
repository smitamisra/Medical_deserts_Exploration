#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  filtered <- reactive({
    if(input$z == 'All'){
      return(hospital_sf)
    }
    hospital_sf%>%
      filter(State == input$z)
  })
  
  output$Hospital_Type <- renderPlot({
    filtered = filtered()
    y= 'Hospital Type'
    #y = 'Hospital Ownership'
    fill = 'State'
    ggplot(data = filtered, aes(y = .data[[y]], 
                                #fill = .data[[fill]]
    )) +
      geom_bar()
  })
  output$Hospital_Ownership <- renderPlot({
    filtered = filtered()
    #y= 'Hospital Type'
    y = 'Hospital Ownership'
    fill = 'State'
    ggplot(data = filtered, aes(y = .data[[y]], 
                                #fill = .data[[fill]]
    )) +
      geom_bar()
  })

  output$mymap <- renderLeaflet({
    
    #render the hospital as per the states
    leaflet(options = leafletOptions(minZoom = 3)) %>%
      addProviderTiles(provider = "CartoDB.Positron") %>%
      setView(lng = -86.7816, lat = 36.1627, zoom = 6) %>%
      setMaxBounds(lng1 = min(filtered()$lng), 
                   lat1 = min(filtered()$lat), 
                   lng2 = max(filtered()$lng), 
                   lat2 = max(filtered()$lat)) %>%
      addCircleMarkers(data = filtered(),
                       radius = 1,
                       color = "white",
                       weight = 0.25,
                       fillColor = "red",
                       fillOpacity = 0.75,
                       label = ~City)
      # addPolygons(data = sf_circles, 
      #             weight = 1, 
      #             opacity = 0.5)%>%
      # addPolygons(data = tn_temp1,
      #             color = "black",
      #             weight = 0.75,
      #             fillColor = "yellow",
      #             fillOpacity = 0.25,
      #             label = ~Tract)
    
    
  })
})
