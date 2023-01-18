

h3("Choice option for the Scatter plot:"),
#select variable for filter with division
selectInput(inputId = "d", 
             label = "TN_region:", 
             choices = c("All" = "All",
                         unique(county_health$Division)),
             inline = TRUE),
#select variable for x-axis
selectInput(inputId = "e",
            label = "X-axis:",
            choices = c("distance to hospital:"= "distance",
                      "Primary Care Physician/100k:" ="PCP_per100K",
                      "Mental Healath Care Physician:" = "MHP_per100K"
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
            choices = c("Hospital Type:" = "Hospita_type",
                        "Hospital Ownership:" = "Hospital_ownership",
                        "Emergency service available:" = "Emergency Services"),
            selcted = "Hospital_type")


if (input_division == "All"){
  plot_data = county_health
}else{plot_data = county_helath%>%
  filter(Division == input$d)}

input_x <- input$e
input_y <- input$f
input_color <- input$color
#input_facet <- "Division"


plot_data%>%
  ggplot(aes(x= .data[[input_x]],
             y = .data[[input_y]],
             color= .data[[input_color]]))+
  facet_wrap(input_facet)+
  geom_point(alpha = 0.5) + 
  geom_smooth(method = "lm")+
  xlab(input$e)+
  ylab(input$f)+
  ggtitle("Relationship among chosen variables") +
  theme(text = element_text(size = 15),
        legend.text = element_text(),
        plot.title = element_text(size = rel(2)),
        axis.text.x = element_text(angle = 90, hjust = 0.2)) 

