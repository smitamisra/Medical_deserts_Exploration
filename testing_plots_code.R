leaflet(options = leafletOptions(minZoom = 3)) %>%
  addProviderTiles(provider = "CartoDB.Positron") %>%
  setView(lng = -86.7816, lat = 36.1627, zoom = 6) %>%
  setMaxBounds(lng1 = min(hospital_sf$lng), 
               lat1 = min(hospital_sf$lat), 
               lng2 = max(hospital_sf$lng), 
               lat2 = max(hospital_sf$lat)) %>%
  addCircleMarkers(data = hospital_sf,
                   radius = 1,
                   color = "white",
                   weight = 0.25,
                   fillColor = "red",
                   fillOpacity = 0.75,
                   label = ~City)%>%
  addPolygons(data = sf_circles, 
              weight = 1, 
              opacity = 0.5)%>%
  addPolygons(data = tn_temp1,
                   #radius = 1,
                   color = "black",
                   weight = 0.75,
                   fillColor = "yellow",
                   fillOpacity = 0.25,
                   label = ~Tract)


ggplot()+geom_sf(data= tntract_hos, aes(fill = Total_Population))
