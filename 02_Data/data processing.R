library(here)
library(quanteda)
library(quanteda.textplots)
library(tidyverse)


#load data
load(here("AI_articles_guardian.RData"))

# cleaning data (removing html tags using regexpr)
articles_df <- articles_df %>% 
  mutate(V3 = gsub("<.*?>", "", V3))



# create corpus and inspect it

myCorpus <- corpus(articles_df, text_field = "V3")

myCorpus <- corpus(myCorpus, docvars = select(articles_df, V1:V2))

head(summary(myCorpus))

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

# inspecting top features 
topfeatures(trimdfm, n=20, decreasing = TRUE)

set.seed(100)
textplot_wordcloud(trimdfm, min_count = 100, 
                   color = c('red', 'pink', 'green', 'purple', 'orange', 'blue'))
