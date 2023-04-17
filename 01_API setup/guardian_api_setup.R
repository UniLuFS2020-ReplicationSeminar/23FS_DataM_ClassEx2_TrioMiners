library(httr)
library(jsonlite)
library(rstudioapi)
library(here)

# Pass API key into environment object
my_api_key <- askForPassword()

# Construct the base URL for the API endpoint
base_url <- "https://content.guardianapis.com/search"

# loop through response pages
articles_df <- data.frame()
for (x in 1:7) {

# Construct a list of query parameters
query_params <- list(
  q = '"artificial intelligence"',
  "from-date" = "2022-09-01",
  "to-date" = "2023-04-17",
  "show-fields" = "body",
  "page" = x,
  "page-size" = 50,
  "show-blocks" = "body"
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

# empty matrix to be filled with content data
articles <- matrix(nrow = 50, ncol = 3, byrow = T)

# loop through contents list and storing date, headline, text
for (i in 1:length(content)) {
  ext_content <- content[[i]]
  articles[i,] <- c(ext_content$webPublicationDate,
               ext_content$webTitle,
               ext_content$fields$body)
}

# appending data from every new page from response
articles_df <- rbind(articles_df, articles)

}

# export data
save(articles_df, file = here("AI_articles_guardian.RData"))






