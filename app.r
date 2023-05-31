library(dplyr)
library(ggplot2)
library(stringr)
library(shiny)
library(plotly)

# DATA SOURCE INFO (ALSO SHOULD PROBABLY SOURCE(DIFFERENT_VIZ_FILES))
source("data_wrangling.r")
df <- read.csv("unifiedData.csv")

# DEFINE WHATS ON DIFFERENT PAGES
intro_pg <- tabPanel("Background",
                     h1("Tobacco Use in Washington state"),
                     h2("include background info, goals, pictures maybe, etc"),
                     p("The story our group intends to tell is about the relationship between tobacco use, 
                       employment status and/or education level, and mental health. Such as how the use of tobacco/smoking, 
                       the status of someone’s employment and/or education level may have an impact on their mental health."),
                     
                     p("We believe this an interesting and compelling story because it touches on a topic that affects a large portion of the 
                       population. In recent years, the awareness of mental health has risen tremendously, and advocating for people to seek 
                       professional help has been more accepted by mainstream culture. In addition, smoking is a widespread habit that affects
                       the lives of millions of people, and its impact on mental health is often overlooked. By exploring this topic, we can 
                       shed light on the issues. Moreover, the impact of employment status and/or education level on smoking and mental health 
                       can highlight the larger issue of socioeconomic inequality. Within the context of the ongoing pandemic, the relationship
                       between smoking and mental health has become even more pertinent. Stress and anxiety levels have been on the rise, which
                       has led people to turn to smoking as a coping mechanism. This can then lead to an increased need for mental health 
                       support, especially for those in lower socioeconomic brackets who may have more limited resources."),
                     
                     p("Some of the data we plan to look at includes causes of smoking in young adults, and the rates of this 
                       over time and what treatment options have been presented across the country. These pieces of data are important
                       to look at because it can show what issues are causing young adults to engage in these harmful behaviors, 
                       and is it because of the lack of mental health care that is causing this. Analyzing this data can help us understand 
                       the correlation between mental health issues and tobacco use. Another question that can be asked is how the rates of
                       young adults using these products changed over time. This is another important question to think about because it can 
                       show what significant cultural and historical changes have affected the rate of mental health in young adults to turn
                       to tobacco use. (Ex. COVID). Another question that is worth asking is how the different states responded to this crisis.
                       This is important to look at, as it can give insight on what solutions are working to combat this issue and what areas 
                       are experiencing this problem at unprecedented levels. With this information, it can give lawmakers a general overview 
                       of this issue and make them aware of what solutions are working, by comparing the data from other states and seeing 
                       what solutions have worked and what have not."),
                     
                     p("Overall, this story is relevant and timely, given the pandemic and the extensive impact it has had on mental health.
                       It is also a topic that affects a large portion of the population and is therefore of interest to many communities.
                       By exploring the relationship between smoking, employment status, education level, and mental health, we can better 
                       understand the complex interplay between these factors."),
                     
                     h2("Datasets that was used:"),
                     tags$ul(
                       tags$li("Behavioral Risk Factor Data: Tobacco Use (2011 to present)"),
                       tags$li("Seasonally Adjusted LAUS Estimates"),
                     )
  
)
  
data_story_pg <- tabPanel("Data Stories",
                          fluidPage(
                            titlePanel("Influential Factors"),
                            
                            tabsetPanel(
                              tabPanel("Employment",
                                       h3("Employment Status and Tobacco Usage"),
                                       h4("This visualization will be focused on the status of one's employment and the use of tobacco by two different groups (those who are employed and those who are unemployed).
                                                This will exclude what educational level and how old the individual is."),
                                       tags$ul(
                                         tags$li("It includes all ages and all types of educational levels"),
                                         tags$li("It includes all types of tobacco use (cigarettes, smokeless tobacco, and e-cigarette"),
                                         tags$li("Includes years from 2011-2019")
                                         ),
                                       p("Over the course of 2011-2019, the cost of living increased, which meant that more people are 
                                         looking for employment, however, this also meant an increase in unemployment, as people are 
                                         unable/struggle to afford their living means. This can cause tremendous stress and a possibility 
                                         to cope with that, is the use of tobacco/smoking, Nicotine, is the addictive substance found in tobacco. 
                                         The effects of nicotine are often followed by a sense of relaxation and calm as the drug is metabolized 
                                         and leaves the body. While some smokers may feel that smoking helps them relax or cope with stress, 
                                         this effect is likely to be temporary and short-lived. Over time, nicotine dependence can actually 
                                         increase anxiety and stress levels, and many smokers report feeling more stressed and anxious when 
                                         they are unable to smoke."),
                                       sidebarLayout(
                                         sidebarPanel(
                                           inputId = "employ_id",
                                           label = "Filter by average employment per year",
                                           min = 2011,
                                           max = 2019,
                                           value = 2015
                                         ),
                                         mainPanel(
                                           plotlyOutput("line_plot")
                                         )
                                       ),
                              ),
  
                              
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
  
  # Employment (plot)
  # Change over time (line plot)
  output$line_plot <- renderPlotly({
    # avg_df <- filter(change_df, avg_employment <= input$employ_id)
    
    change_over_time_graph <- ggplot(data = change_df, aes(x = Year, y = avg_employment)) +
      geom_line(aes(col = EmploymentStatus)) +
      geom_point(size = 2) +
      labs(y = "Average Employment/Unemployment Rate", x = "Years", color = "Employment Status") +
      scale_color_manual(values = c("#446c63", "#7a9380")) +
      theme_classic() +
      theme(
        axis.title.x = element_text(color = "#446c63", size = 12, face = "bold"),
        axis.title.y = element_text(color = "#c3b6ad", size = 12, face = "bold")
      )
    
    return(change_over_time_graph)
  })
  
  # Education Level and Tobacco Use (plot)
  
  # Relative Influences (plot)
}




shinyApp(ui, server)
