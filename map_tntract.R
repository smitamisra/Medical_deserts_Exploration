

factpal <- colorFactor(topo.colors(5), tn_temp1$group)



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
               label = ~County)%>%
    addPolylines(data = tn_temp1%>%
                 filter(County == "Davidson")%>%
                 select(distance), 
               color = "black", 
               opacity = 0.8, 
               weight = 1.5, 
               label = ~distance)%>%
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
              opacity = 0.5)%>%
  addLegend(
    pal = factpal,
    position = 'bottomleft',
    values = factor(tn_temp1$group),
    title = 'Distance to facility')
  
  
map


