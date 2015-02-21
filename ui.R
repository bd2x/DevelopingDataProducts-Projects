library(shiny)

# Define UI for selecting commodity
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("Commodity ForecastApp"),

  # Sidebar with controls to select the commodity to plot 
  # and whether decomposition should be done
  sidebarPanel(
    selectInput("dataset", "Commodity:",
                list("Product A" = "Product_A", 
                     "Product B" = "Product_B", 
                     "All" = "AllProducts")),
					 
    sliderInput("range", "forecast horizon in months:", 
                min=0, max=24, value=12),

    checkboxInput("decompose", "Decompose?", TRUE)
  ),

  # Show the caption and plot of the requested variable
  mainPanel(
h3(textOutput("commSelected")),  
tabsetPanel(
    tabPanel("Forecast Plot", plotOutput("CommForecast")),
    tabPanel("Decomposition", plotOutput("CommodityDecomp")),
    tabPanel("Data Table", verbatimTextOutput("CommodityTable")),
    tabPanel("Help", htmlOutput("Help"))
  )
  )
))