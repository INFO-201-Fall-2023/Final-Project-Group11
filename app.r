library(dplyr)
library(ggplot2)
library(stringr)
library(shiny)

# DATA SOURCE INFO (ALSO SHOULD PROBABLY SOURCE(DIFFERENT_VIZ_FILES))
source("data_wrangling.r")
df <- read.csv("unifiedData.csv")


# DEFINE WHATS ON DIFFERENT PAGES
intro_pg <- tabPanel("Background",
                     h2("Tobacco Use in Washington state"),
                     p("include background info, goals, pictures maybe, etc")
  
)
  
data_story_pg <- tabPanel("Data Stories",
                          fluidPage(
                            titlePanel("Influential Factors"),
                            
                            tabsetPanel(
                              tabPanel("Employment",
                                       h3("Employment Status and Tobacco Usage"),
                                       p("maybe a little info/summary at bottom")),
                              tabPanel("Education",
                                       h3("Education Level and Tobacco Usage"),
                                       p("maybe a little info/summary at bottom")),
                              tabPanel("Relative Influences",
                                       h3("Relative Influences on Tobacco Usage"),
                                       p("maybe a little info/summary at bottom/explain why we have this viz on top of the other two"))
                            )
                          )
  
)
  
takeaway_pg <- tabPanel("Takeaways",
                        h2("Reflections"),
                        h4("Employment"),
                        p("what did we get from employment?"),
                        h4("Education"),
                        p("what did we get from education?"),
                        h4("Overall"),
                        p("final takeaway")
  
)

# UI NAVIGATION
ui <- navbarPage("Tobacco Use",
                 intro_pg,
                 data_story_pg,
                 takeaway_pg
)



# DEFINE SERVER LOGIC
server <- function(input, output){
  
}




shinyApp(ui, server)
