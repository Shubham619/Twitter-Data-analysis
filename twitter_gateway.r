library('RCurl')
library('RJSONIO')
library('stringr')


GetUserId<- function(userName) {
  url = 'https://api.twitter.com/1.1/users/lookup.json?'
  auth = "5618626.1fb234f.1b941996c2bb4c6ab7e25bf16a2c3ea7"
  jsonData = getURL(paste0(url, 'access_token=', auth, '&q=', userName))
  rData = fromJSON(jsonData)
  userID = rData$data[[1]][["id"]]
  return (userID)
}

