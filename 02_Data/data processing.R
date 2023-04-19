library(here)
library(quanteda)
library(quanteda.textplots)
library(tidyverse)

# I got an error creating the corpus from the improted dataframe:
# dimnames <- fixupDN(.Object@Dimnames) : missing value where TRUE/FALSE needed
# thats why I filter empty strings and NAs

#load data
load(here("AI_articles_guardian.RData"))

# check for missing values and empty string + cleaning
any(is.na(articles_df))
any_empty_strings <- any(apply(articles_df, 1, function(x) any(nchar(x) == 0)))
any_empty_strings

# cleaning data (removing html tags using regexpr)
articles_df <- articles_df %>% 
  mutate(V3 = gsub("<.*?>", "", V3)) %>% 
  # NAs
  mutate(V1 = if_else(is.na(V1), "MISSING_TEXT", V1)) %>%  # Na handling
  mutate(V2 = if_else(is.na(V2), "MISSING_TEXT", V2)) %>%  # Na handling
  mutate(V3 = if_else(is.na(V3), "MISSING_TEXT", V3)) %>%  # Na handling
  # empty stings
  mutate(across(everything(), ~ if_else(.x == "", "MISSING_TEXT", .x), .names = 'new_{.col}'))

# check for missing values and empty string (again)
any(is.na(articles_df))
any_empty_strings <- any(apply(articles_df, 1, function(x) any(nchar(x) == 0)))
any_empty_strings

# create corpus and inspect it
myCorpus <- corpus(articles_df[1:200,], text_field = "V3") # include only 200 most relevant articles
myCorpus <- corpus(myCorpus, docvars = select(articles_df[1:200,], V1:V3))

myCorpus

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
myDfm <- dfm(tok)
trimdfm <- dfm_trim(myDfm, min_termfreq = 10)

# inspecting top features by plotting
topfeatures(trimdfm, n=20, decreasing = TRUE)

# word cloud
set.seed(100)
textplot_wordcloud(trimdfm, min_count = 100, 
                   color = c('red', 'pink', 'green', 'purple', 'orange', 'blue'))

# frequency bars
library("quanteda.textstats")
features_dfm <- textstat_frequency(trimdfm, n = 100)

# Sort by reverse frequency order
features_dfm$feature <- with(features_dfm, reorder(feature, -frequency))

ggplot(features_dfm, aes(x = feature, y = frequency)) +
  geom_col(fill = "steelblue") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "Corpus Top 100 features",
       x = "Feature",
       y = "Frequency")


# export dfm
save(trimdfm, file = here("AI_dfm_guardian.RData"))

