

#

library(shiny)
library(twitteR)

options(httr_oauth_cache=T)  
consumer_key <- "yvsclv2zOiY2sB801YY4H1IcH"


consumer_secret <-"Q9Yb5z9gdlOeTXojTTAsNWVQrhbWpjkkYE2bKb3h32FNxB5ZdF"
access_token <-"441550750-nQBw6A06qkZXPl7MTvpOdBPBX2a1r6BshqFw2c9t"
access_secret <-"ipd3PaewrO12c9IoNlD1ERUMcKKqC3GOYVyibGdgwVlys"


#Setup twitter Connection. 
setup_twitter_oauth(consumer_key,consumer_secret,access_token,access_secret)
shinyServer(function(input, output) {
  
  userFromHandle = NULL
  userFollowers = NULL
  
  FillUserTable <- function () {
    # FETCH DATA
    if (input$twitterHandle != ""){
      userFromHandle <<- getUser(input$twitterHandle)
    
      # Data from objects:       
      userId = userFromHandle$id
      userName = userFromHandle$name
      followerCount = userFromHandle$followersCount
      
      
      #Prepare Table Infomation:
      colNames = c("User ID", "Name", "Number of Followers")
      userData = c(userId, userName, followerCount)
      
      #COnstruct Table:
      if (!is.null(userData)) {
        userTable = matrix(data = userData , ncol = length(colNames), dimnames = list('',colNames), byrow = TRUE)
        userTable = as.table(userTable) 
        return (userTable)
      }
    }
  }
  
  output$twitTable <- renderTable({
    FillUserTable()
  })

#   observeEvent(input$fetchData, {
#     if (input$twitterHandle != "" && !is.null(userFromHandle$followersCount)) {
#       
#     }
#   })
  FetchFollowers <- function () {
    if (input$maxFollowers == 0) {
      return (userFromHandle$getFollowers())
    } else {
      return (userFromHandle$getFollowers(input$maxFollowers))
    }
  }
  
  FollowerData = function () {
    #Fetch followers data
    withProgress(message = "Downloading Data Now", expr = {
      setProgress(value = 0)
      userFollowers <<- FetchFollowers()
      setProgress(value = 1)
    })
    
    # prune the user data list into a table for csv
    if (is.list(userFollowers)) {
      df = twListToDF(userFollowers)
    } else {
      df = userFollowers
    }
    return (df)
  }
  
  output$downloadData <- downloadHandler(
    filename = function (){
      paste(input$twitterHandle, '_twitter_followers.csv', sep = '')
    },
    content = function (file) {
      write.csv(FollowerData(), file)
    }
  )
})

