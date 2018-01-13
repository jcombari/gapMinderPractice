library(shiny)
library(tidyverse)

ui <- fluidPage(
   titlePanel("Old Faithful Geyser Data"),
   sidebarLayout(
      sidebarPanel(
        uiOutput("radio")
      ),
      mainPanel(
         plotOutput("acreedor"),
         tableOutput("totalGastado")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  data <- readRDS("../../data/data_tidy.rds")
   
  output$acreedor <- renderPlot({
    if (!is.null(input$select_mes)) {
      data_graph <- data %>%
        filter(MES %in% input$select_mes)
      ggplot(data_graph) +
        geom_bar(aes(acreedor))
    }
  })
  
  output$totalGastado <- renderTable({
     data %>%
      filter (MES %in% input$select_mes) %>%
      arrange(desc(PAGO)) %>%
      select(RAZÓN, TIPO, PAGO, FECHA) %>%
      slice(1:5)
  }
  )
  
  
  output$radio <- renderUI({
    choices <- setNames(unique(data$MES), unique(data$MES))
    checkboxGroupInput("select_mes", label = h3("Mes"), 
                       choices = choices,
                       selected = "ENERO")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

