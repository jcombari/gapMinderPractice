library(shiny)
library(tidyverse)
library(lubridate)

ui <- fluidPage(
   titlePanel("Pay by month"),
   sidebarLayout(
      sidebarPanel(
        uiOutput("select"),
        textInput(inputId = "title", 
                   label = "Escribe un nuevo título",
                   value = "Grafico de gastos por mes "),
        uiOutput("radio")
      ),
      mainPanel(
         plotOutput("acreedor1"),
         plotOutput("acreedor2"),
         tableOutput("totalGastado"),
                   textInput(inputId = "title", 
                             label = "Escribe un nuevo título",
                             value = "Grafico de gastos por mes ")
      )
      
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  data <- readRDS("../../data/data_tidy.rds")
  #data <- readRDS("../data/data_tidy.rds") 
  output$acreedor1 <- renderPlot({
    if (!is.null(input$select_tipo)) {
      data_graph <- data %>%
        filter(TIPO %in% input$select_tipo)
      ggplot(data_graph, aes(factor(month(FECHA, label = TRUE)),PAGO, fill=acreedor)) +
        geom_boxplot() +
        scale_fill_hue(l=40, c=35)
    }
  })
            
  output$acreedor2 <- renderPlot({
    data_graph <- data %>%
        filter(MES %in% input$select_mes)
      ggplot(data_graph) +
        geom_boxplot(aes(acreedor, PAGO))+
        labs(title = input$title) 
  })
  
  output$totalGastado <- renderTable({
     data %>%
      filter (MES %in% input$select_mes) %>%
      arrange(desc(PAGO)) %>%
      select(RAZÓN, TIPO, PAGO, FECHA) %>%
      slice(1:5)
  })
  
  
  output$radio <- renderUI({
    choices <- setNames(unique(data$MES), unique(data$MES))
    checkboxGroupInput("select_mes", label = h3("Mes"), 
                       choices = choices,
                       selected = "salud")
  })
  
  
  output$select <- renderUI({
    choices <- setNames(unique(data$TIPO), unique(data$TIPO))
    selectInput("select_tipo", label = h3("TIPO"), 
                       choices = choices,
                       selected = "salud")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

