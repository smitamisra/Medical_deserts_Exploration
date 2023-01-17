



factpal <- colorFactor(topo.colors(5), tn_temp1$group)
hospal <- colorFactor(terrain.colors(5), tn_temp1$`Hospital Type`)

popup_hos <-
  paste(
    "<b>TN_Division:</b>", tn_temp1$Division, "<br>",
    "<b>TN_County:</b>", tn_temp1$County, "<br>",
    "<b>TN_censustract:</b>", tn_temp1$NAMELSAD, "<br>",
    "<b>Distance_to_nearest_Hospital(miles):</b>", tn_temp1$distance, "<br>",
    "<b>Nearest_Hospital:</b>", tn_temp1$`Facility ID`, "<br>",
    "<b>Hospital_address:</b>", tn_temp1$comp_address, "<br>",
    "<b>Hospital_Phone#:</b>", tn_temp1$`Phone Number`, "<br>",
    "<b>Hospital_Type:</b>", tn_temp1$`Hospital Type`, "<br>",
    "<b>Hospital_Ownership:</b>", tn_temp1$`Hospital Ownership`, "<br>",
    "<b>Emergency Services:</b>", tn_temp1$`Emergency Services`, "<br>")



map <- leaflet(options = leafletOptions(minZoom = 3)) %>%
  addProviderTiles(provider = "CartoDB.PositronNoLabels") %>%
  setView(lng = -86.7816, lat = 36.1627, zoom = 6) %>%
  setMaxBounds(lng1 = -86.7816 + 1, 
               lat1 = 36.1627 + 1, 
               lng2 = -86.7816 - 1, 
               lat2 = 36.1627 - 1) %>%
  addPolygons(data = tn_temp1%>%
                filter(County == "Davidson"),
               color = ~factpal(`group`), 
               opacity = 0.05, 
               weight = 0.5, 
               label = popup_hos)%>%
    addPolylines(data = tn_temp1%>%
                 filter(County == "Davidson")%>%
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
                   label = ~`Facility Name`)%>%
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
  
  
map


filtered_tract <- tn_temp1%>%
  filter(County == "Davidson")
DT::renderDataTable({
  filtered_tract()[, c("NAMELSAD", "Divison", 
                       "distance", "group", "Facility Name", 
                       "State", "Median_Household_Income", "Median_Age" )]
})