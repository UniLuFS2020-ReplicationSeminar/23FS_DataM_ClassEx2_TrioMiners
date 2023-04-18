library(here)
library(quanteda)
library(quanteda.textplots)
library(tidyverse)

# I got an error creating the corpus from the improted dataframe:
# dimnames <- fixupDN(.Object@Dimnames) : missing value where TRUE/FALSE needed


#load data
load(here("AI_articles_guardian.RData"))


# check for missing values and empty string + cleaning

print(any(is.na(articles_df$V3)))
print(any(articles_df$V3 == ""))

# cleaning data (removing html tags using regexpr)
articles_df <- articles_df %>% 
  mutate(V1 = if_else(is.na(V1), "MISSING_TEXT", V1)) %>%  # Na hanlding
  mutate(V2 = if_else(is.na(V2), "MISSING_TEXT", V2)) %>%  # Na hanlding
  mutate(V3 = if_else(is.na(V3), "MISSING_TEXT", V3)) %>%  # Na hanlding
  mutate(V3 = gsub("<.*?>", "", V3))

# check for missing values and empty string (again)
print(any(is.na(articles_df$V3))) # should return false
print(any(articles_df$V3 == "")) # should return false

# create corpus and inspect it
myCorpus <- corpus(articles_df, text_field = "V3")
myCorpus <- corpus(myCorpus, docvars = select(articles_df, V1:V2))


head(summary(myCorpus))
summary(myCorpus)

# tokenize text and remove noise

tok <- tokens(myCorpus , remove_punct = TRUE, 
               remove_numbers=TRUE, 
               remove_symbols = TRUE, 
               split_hyphens = TRUE, 
               remove_separators = TRUE)
tok <- tokens_remove(tok, stopwords("en"))
tok <- tokens_wordstem(tok)

# create dfm and trim it
myDfm <- dfm(tok, )
trimdfm <- dfm_trim(myDfm, min_termfreq = 10)

# inspecting top features 
topfeatures(trimdfm, n=20, decreasing = TRUE)

set.seed(100)
textplot_wordcloud(trimdfm, min_count = 100, 
                   color = c('red', 'pink', 'green', 'purple', 'orange', 'blue'))
