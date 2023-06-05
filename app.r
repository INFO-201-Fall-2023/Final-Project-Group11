library(shiny)
library(ggplot2)
library(plotly)
library(dplyr)
library(stringr)

source("Final Project.R")

df <- read.csv("unifiedData.csv")

# UI
ui <- fluidPage(
  titlePanel("Main Factors of Tobacco Use"),
  br(),
  p("This pie chart displays the three main factors of tobacco use: Education Level
    (below 12th grade), Unemployment Rate above level 8(indicating a long time since 
    employment, and also the Labor Force, which includes manual and physical labor."),
  br(),
  p("These are important factors to discuss, and check to find out which of these factors are
    the most recurring among tobacco users, and how it can be mitigated long-term. This data
    can help find common trends of tobacco users and other behaviors to find a relationship 
     between these potential factors and how they impact tobacco usages"),
  br(),
  tags$style(HTML("
    h2 {
            background-color: #ccd5d8;
            color: Black;
            }")),
)
sidebarLayout(
  sidebarPanel(
    selectInput(inputId = "Factors", label = "Click to learn more about the Factor", choices = c("Education Level", "Unemployment Rate", "Labor Force"), selected = NULL),
    br(),
  ),
  mainPanel(
    h3("Looking at the Main Factors of Tobacco Use"),
    plotlyOutput(outputId = "pie_chart")
  ),
)


server <- function(input, output) {
  pie_data <- data.frame(
    Category = c("Education", "Labor Force", "Unemployment"),
    Count = unlist(category_counts)
  )
  
  # Create the pie chart using ggplot2
  pie_chart <- ggplot(pie_data, aes(x = "", y = Count, fill = Category)) +
    geom_bar(stat = "identity", width = 1) +
    coord_polar("y", start = 0) +
    scale_fill_manual(values = c("Education" = "forestgreen", "Labor Force" = "seagreen4", "Unemployment" = "tan")) +
    theme_void() +
    labs(title = "Proportion of Current Smoking Users", fill = "Category")
  
  output$pie_chart <- renderPlotly({
    # Convert ggplot to plotly
    pie_chart <- ggplotly(pie_chart, tooltip = c("text", "percent"))
    
    # Return the interactive plotly object
    pie_chart
  
}


shinyApp(ui = ui, server = server)
