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
      geom_bar(fill = "blue")+
      ylab("")+
      xlab("Number of Facilities")+
      ggtitle("Facility Type")+
      theme(axis.text.x = element_text(face="bold", color="#993333", 
                                       size=12, angle=45),
            axis.text.y = element_text(face = "bold", color ="#993333", angle = 30 ),
            plot.title = element_text(face = "bold", color = "blue", size = 14),
            axis.title.x = element_text(color="blue", size=14, face="bold"))
  })
  output$Hospital_Ownership <- renderPlot({
    filtered = filtered()
    fill = 'Hospital Type'
    y = 'Hospital Ownership'
    #fill = 'State'
    ggplot(data = filtered, aes(y = .data[[y]], 
                                #fill = .data[[fill]]
    )) +
      geom_bar(fill = "red")+
      ylab("")+
      xlab("Number of Facilities")+
      ggtitle("Ownership kind")+
      theme(axis.text.x = element_text(face="bold", color="#993333", 
                                       size=12, angle=45),
            axis.text.y = element_text(face = "bold", color ="#993333", angle = 30 ),
            plot.title = element_text(face = "bold", color = "blue", size = 14),
            axis.title.x = element_text(color="blue", size=14, face="bold"))
  })
  
  output$mymap <- renderLeaflet({
    
    pop_hos <-
      paste(
        "<b>Hospital Name:</b>", hospital_sf$`Facility Name`, "<br>",
        "<b>Hospital City:</b>", hospital_sf$City, "<br>",
        "<b>Hospita Sate:</b>", hospital_sf$State, "<br>",
        "<b>CMS Rating:</b>", hospital_sf$`Hospital overall rating`, "<br>",
        "<b>Type :</b>", hospital_sf$`Hospital Type`, "<br>",
        "<b>Ownership:</b>", hospital_sf$`Hospital Ownership`, "<br>",
        "<b>Emergency Services available:</b>", hospital_sf$`Emergency Services`,
        "<br>")%>%
      lapply(htmltools::HTML)
    
    #render the hospital as per the states
    leaflet(options = leafletOptions(minZoom = 3)) %>%
      addProviderTiles(provider = "CartoDB.Positron") %>%
      setView(lng = -86.7816, lat = 36.1627, zoom = 6) %>%
      setMaxBounds(lng1 = min(filtered()$lng), 
                   lat1 = min(filtered()$lat), 
                   lng2 = max(filtered()$lng), 
                   lat2 = max(filtered()$lat)) %>%
      addCircleMarkers(data = filtered(),
                       radius = 2,
                       color = "white",
                       weight = 0.25,
                       fillColor = "red",
                       fillOpacity = 0.75,
                       label = pop_hos)
  })
  
  output$map <- renderLeaflet({
    
    input_county <- input$s
    
    factpal <- colorFactor(topo.colors(5), tn_temp1$group)
    hospal <- colorFactor(terrain.colors(5), tn_temp1$`Hospital Type`)
    
    popup_tntract <-
      paste(
        "<b>TN_Division:</b>", tn_temp1$Division, "<br>",
        "<b>TN_County:</b>", tn_temp1$County, "<br>",
        "<b>TN_censustract:</b>", tn_temp1$NAMELSAD, "<br>",
        "<b>Distance_to_nearest_Hospital(miles):</b>", tn_temp1$distance, "<br>",
        "<b>Nearest_Hospital:</b>", tn_temp1$`Facility Name`, "<br>",
        "<b>Hospital_address:</b>", tn_temp1$comp_address, "<br>",
        "<b>Hospital_Phone#:</b>", tn_temp1$`Phone Number`, "<br>",
        "<b>Hospital_Type:</b>", tn_temp1$`Hospital Type`, "<br>",
        "<b>Hospital_Ownership:</b>", tn_temp1$`Hospital Ownership`, "<br>",
        "<b>Emergency Services:</b>", tn_temp1$`Emergency Services`, "<br>")%>%
      lapply(htmltools::HTML)
    
    pop_hos <-
      paste(
        "<b>Hospital Name:</b>", hospital_sf$`Facility Name`, "<br>",
        "<b>Hospital City:</b>", hospital_sf$City, "<br>",
        "<b>Hospita Sate:</b>", hospital_sf$State, "<br>",
        "<b>CMS Rating:</b>", hospital_sf$`Hospital overall rating`, "<br>",
        "<b>Type :</b>", hospital_sf$`Hospital Type`, "<br>",
        "<b>Ownership:</b>", hospital_sf$`Hospital Ownership`, "<br>",
        "<b>Emergency Services available:</b>", hospital_sf$`Emergency Services`,
        "<br>")%>%
      lapply(htmltools::HTML)
    
    
    
       
    
    map <- leaflet(options = leafletOptions(minZoom = 3)) %>%
      addProviderTiles(provider = "CartoDB.PositronNoLabels") %>%
      setView(lng = -86.7816, lat = 36.1627, zoom = 8) %>%
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
      addPolygons(data = sf_circles%>%
                    filter(State == "TN"), 
                  weight = 1,
                  fillColor = ~hospal(`Hospital Type`),
                  opacity = 0.5)%>%
      addCircleMarkers(data = hospital_sf,
                       radius = 1,
                       color = "white",
                       weight = 1.0,
                       fillColor = "red",
                       fillOpacity = 0.75,
                       label = pop_hos)%>%
      
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
  
  output$Dependency <- renderPlot({
    if (input$d == "All"){
      plot_data = county_health
    }else{plot_data = county_health%>%
      filter(Division == input$d)}
    
    input_x <- input$e
    input_y <- input$f
    input_color <- input$color
    #input_facet <- "Division"
    
    
    plot_data%>%
      ggplot(aes(x= .data[[input_x]],
                 y = .data[[input_y]],
                 color= .data[[input_color]]))+
      #facet_wrap(input_facet)+
      geom_point(alpha = 0.5) + 
      geom_smooth(method = "lm")+
      xlab(input$e)+
      ylab(input$f)+
      ggtitle("Relationship among chosen variables") +
      theme(text = element_text(size = 15),
            legend.text = element_text(),
            plot.title = element_text(size = rel(2)),
            axis.text.x = element_text(angle = 90, hjust = 0.2))
  })
  output$lm_summary <- renderPrint({
    if (input$d == "All"){
      plot_data = county_health
    }else{plot_data = county_health%>%
      filter(Division == input$d)}
    plot_data <- plot_data%>%
      mutate(distance = as.numeric(distance))
    formula= glue::glue("{input$f} ~{input$e}")
    lm(formula = formula, data = plot_data)%>%
      summary()
  })
})
