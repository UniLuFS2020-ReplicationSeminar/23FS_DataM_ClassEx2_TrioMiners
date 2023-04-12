library(httr)
library(jsonlite)
library(rstudioapi)

# Pass API key into environment object
my_api_key <- askForPassword()

# Construct the base URL for the API endpoint
base_url <- "https://content.guardianapis.com/search"

# Construct a list of query parameters
query_params <- list(
  q = "artificial intelligence",
  "from-date" = "2023-01-01",
  "to-date" = "2023-03-31",
  "show-fields" = "body",
  "page-size" = 10,
  "show-blocks" = "body",
  "api-key" = my_api_key
  
)


# Construct the request header with the API key
headers <- c("api-key" = my_api_key)

# Send the request to the API and get the response
g_response <- httr::GET(base_url, add_headers(.headers=headers), 
                        query = query_params)

# Check status of response
http_status(g_response)

# Extract the content of the response 
content <- content(g_response, as = "parsed")
content <- content$response$results
content <- content[[1]]
content$webTitle
content$fields$body










