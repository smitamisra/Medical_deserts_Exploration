

popup_hos <-
  paste(
    "<b>Hospital Name:</b>", hospital_sf$`Facility Name`, "<br>",
    "<b>Hospital City:</b>", hospital_sf$City, "<br>",
    "<b>Hospita Sate:</b>", hospital_sf$State, "<br>",
    "<b>CMS Rating:</b>", hospital_sf$`Hospital overall rating`, "<br>",
    "<b>Type :</b>", hospital_sf$`Hospital Type`, "<br>",
    "<b>Ownership:</b>", hospital_sf$`Hospital Ownership`, "<br>",
    "<b>Emergency Services available:</b>", hospital_sf$`Emergency Services`, "<br>")