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
    fill = 'Hospital Ownership'
    #fill = 'State'
    ggplot(data = filtered, aes(y = .data[[y]], 
                                #fill = .data[[fill]]
    )) +
      geom_bar()
  })
  output$Hospital_Ownership <- renderPlot({
    filtered = filtered()
    fill = 'Hospital Type'
    y = 'Hospital Ownership'
    #fill = 'State'
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
    })
    
  output$map <- renderLeaflet({
      
      input_county <- input$s
      
      factpal <- colorFactor(topo.colors(5), tn_temp1$group)
      hospal <- colorFactor(terrain.colors(5), tn_temp1$`Hospital Type`)
      
      popup_tntract <-
        HTML(paste(
          "<b>TN_Division:</b>", tn_temp1$Division, "<br>",
          "<b>TN_County:</b>", tn_temp1$County, "<br>",
          "<b>TN_censustract:</b>", tn_temp1$NAMELSAD, "<br>",
          "<b>Distance_to_nearest_Hospital(miles):</b>", tn_temp1$distance, "<br>",
          "<b>Nearest_Hospital:</b>", tn_temp1$`Facility ID`, "<br>",
          "<b>Hospital_address:</b>", tn_temp1$comp_address, "<br>",
          "<b>Hospital_Phone#:</b>", tn_temp1$`Phone Number`, "<br>",
          "<b>Hospital_Type:</b>", tn_temp1$`Hospital Type`, "<br>",
          "<b>Hospital_Ownership:</b>", tn_temp1$`Hospital Ownership`, "<br>",
          "<b>Emergency Services:</b>", tn_temp1$`Emergency Services`, "<br>"))
      
      popup_hos <-
        HTML(paste(
          "<b>Hospital Name:</b>", hospital_sf$`Facility Name`, "<br>",
          "<b>Hospital City:</b>", hospital_sf$City, "<br>",
          "<b>Hospita Sate:</b>", hospital_sf$State, "<br>",
          "<b>CMS Rating:</b>", hospital_sf$`Hospital overall rating`, "<br>",
          "<b>Type :</b>", hospital_sf$`Hospital Type`, "<br>",
          "<b>Ownership:</b>", hospital_sf$`Hospital Ownership`, "<br>",
          "<b>Emergency Services available:</b>", hospital_sf$`Emergency Services`, "<br>"))
      
      map <- leaflet(options = leafletOptions(minZoom = 3)) %>%
        addProviderTiles(provider = "CartoDB.PositronNoLabels") %>%
        setView(lng = -86.7816, lat = 36.1627, zoom = 6) %>%
        setMaxBounds(lng1 = -86.7816 + 1, 
                     lat1 = 36.1627 + 1, 
                     lng2 = -86.7816 - 1, 
                     lat2 = 36.1627 - 1) %>%
        addPolygons(data = tn_temp1%>%
                      filter(County == input_county),
                    color = ~factpal(`group`), 
                    opacity = 0.05, 
                    weight = 0.5, 
                    label = popup_tntract)%>%
        addPolylines(data = tn_temp1%>%
                       filter(County == input_county)%>%
                       select(distance), 
                     color = "black", 
                     opacity = 0.8, 
                     weight = 1.5, 
                     label = ~tn_temp1$NAMELSAD)%>%
        addCircleMarkers(data = hospital_sf,
                         radius = 1,
                         color = "white",
                         weight = 1.0,
                         fillColor = "red",
                         fillOpacity = 0.75,
                         label = popup_hos)%>%
        addPolygons(data = sf_circles%>%
                      filter(State == "TN"), 
                    weight = 1,
                    fillColor = ~hospal(`Hospital Type`),
                    opacity = 0.5)%>%
        addLegend(
          pal = factpal,
          position = 'bottomleft',
          values = factor(tn_temp1$group),
          title = 'Distance to facility')
      
      map})
      
        filtered_tract <- reactive({tn_temp1%>%
        filter(County == input$s)%>%
            st_drop_geometry()
        })
      output$table <- DT::renderDataTable({
        filtered_tract()[, c("NAMELSAD", "Division", 
                             "distance", "group", "Facility Name", "Hospital Type", 
                             "Hospital Ownership",
                             "State", "Median_Household_Income", "Median_Age")]
    
      
    
    
  })
})
