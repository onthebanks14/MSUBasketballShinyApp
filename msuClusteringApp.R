library(plotly)
library(collapsibleTree)
library(dplyr)
library(cluster)

library(ggplot2)
library(readr)
library(datasets)
library(corrplot)
library(stats)
library(ggrepel)
library(textir) 
library(rstudioapi)
library(plotly)

ui <- fluidPage(
  
  
  # App title ----
  titlePanel("Segmenting MSU Basketball Players"),
  
  br(),
  
  # Main panel for displaying outputs ----
  mainPanel(
    
    # Output: Tabset w/ plot, summary, and table ----
    tabsetPanel(type = "tabs",
                tabPanel("Interactive Plot",
                         fluidRow(
                                  column(3, htmlOutput("explainer")),
                                  column(9, plotlyOutput("plot", height = "475px"))
                         )
                        ),
                tabPanel("Cluster Tree", 
                         fluidRow(
                           htmlOutput("explainer1"),
                           collapsibleTreeOutput("dend",
                                                 height = "600"))))))

fluidRow(12,
         column(6,plotOutput('plot1')),
         column(6,plotOutput('plot2'))
)

server <- function(input, output) {
  
  #get data
  df1 <- read.csv("C:/Users/lukebunge14/Desktop/MSUBasketballShinyApp/finalMSUClusteringData.csv")
  df1$ClusterType <- ifelse(df1$cluster==4,"Role Player - Wing",
                            ifelse(df1$cluster==2, "Productive Big Man",
                                   ifelse(df1$cluster==1,"Productive Wing",
                                          ifelse(df1$cluster==3,"Role Player - Big Man",df1$cluster))))

  output$explainer <- renderUI(
    HTML(paste(h4("How to interpret:"),
          "- The proximity of a player to another player shows their similarity based 
          on their per game statistics.",
          "- Axes represent a combination of per game statistics 
          that seek to explain as much of the
          differences between players as possible. In this case, two thirds of the difference 
          between players is represented in the chart.",
          "- Per Game stats used for comparison include: PTS, 2PA, 2PT%, 3PA, 3PT%, TRB, AST, STL, BLK, TOV",
          "- Players with less than 10MP per game were removed",
          "- Data dates back to 1998. 2018-2019 data through 2/24/19 (source: Sports-Refernce.com)",
          sep = "<br/>"))
    
  )
  
  output$explainer1 <- renderUI(
    HTML(paste(h5("Click on a group to eaisly view 
                  players in each segment (alphabetical order)")))
  )
  
  output$dend <- renderCollapsibleTree({
    
    msu_basketball <- df1

    collapsibleTree(
      msu_basketball,
      hierarchy = c("ClusterType", "Player"),
      width = 600,
      zoomable = F
    )
  })
  
  f <- list(
    family = "Courier New, monospace",
    size = 12,
    color = "#7f7f7f"
  )
 
  x <- list(
    title = "PC 1 (Explains 39% of Diff between Players)",
    titlefont = f
  )
  
  y <- list(
    title = "PC 2 (Explains 28% of Diff between Players)",
    titlefont = f
  )
  
  output$plot <- renderPlotly({
    plot_ly(df1, x = df1$X1 , y = df1$X2, text = df1$Player,
            mode = "markers", color = df1$ClusterType, marker = list(size = 11)) %>%
      layout(autosize = F,
             title = 'Clustering MSU Players',
             xaxis = x, yaxis = y)
  })
  

}

shinyApp(ui, server)
