library(httr)
library(jsonlite)
library(rstudioapi)

# Pass API key into environment object
my_api_key <- askForPassword()

# Construct the base URL for the API endpoint
base_url <- "https://content.guardianapis.com/search"

# Construct a list of query parameters
query_params <- list(
  q = "climate change",
  "query-fields" = "headline",
  "from-date" = "2020-01-01",
  "to-date" = "2020-01-31",
  "show-fields" = "body"
  
)

# Construct the request header with the API key
headers <- c("api-key" = my_api_key)

# Send the request to the API and get the response
g_response <- httr::GET(base_url, query_params, add_headers(.headers=headers))

# Check status of response
http_status(g_response)

# Extract the content of the response 
content <- content(g_response, as = "parsed")
content <- content$response$results
content <- content[[1]]
content$webTitle
article_link <- content$webUrl










