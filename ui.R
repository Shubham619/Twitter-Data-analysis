


library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Twitter Followers"),
  
  # Sidebar with a input for user input
  sidebarPanel(
    textInput('twitterHandle',"Twitter Handle",""),
    sliderInput('maxFollowers',"Followers Download Limit",min = 0,max = 5000,value = 5000),
    downloadButton('downloadData',"Download Followers Data")
  ),
  
  mainPanel(
    tableOutput("twitTable")
  )
))
