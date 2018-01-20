#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(maps)
library(RColorBrewer)

ui <- fluidPage(
   
   # Application title
   titlePanel("La mejor App para ubicar un lugar en función de latitud y longitud"),
   
   sidebarLayout(
     sidebarPanel(
    
     # Copy the line below to make a number input box into the UI.
     numericInput("lat_value", label = h3("Latitud"), value = -34),
     numericInput("long_value", label = h3("Longitud"), value = -64),
     # Copy the line below to make an action button
     actionButton("clicks", label = "Go!")
     ),
     
     mainPanel(
     leafletOutput("mymap")
     )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  rv<- reactiveValues(lat=-34, long=-64)
  
  observeEvent(input$clicks, {
    rv$lat<-input$lat_value
    rv$long<-input$long_value
    print(rv$lat)
    print(rv$long)
  })    
  
  # You can access the value of the widget with input$action, e.g.
  output$mymap  <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%  # Add default OpenStreetMap map tiles
      addMarkers(lat=rv$lat, lng=rv$long, popup="Ubicación de coordenadas") %>%
      setView(lat=rv$lat, lng=rv$long, zoom=3)
    })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

