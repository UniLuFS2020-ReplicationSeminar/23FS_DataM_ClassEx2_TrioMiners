library(here)
library(quanteda)
library(quanteda.textplots)


#load data
load(here("AI_articles_guardian.RData"))


# create corpus and inspect top features

myCorpus <- corpus(articles_df, text_field = "V3")
head(summary(myCorpus))

tok2 <- tokens(myCorpus , remove_punct = TRUE, remove_numbers=TRUE, remove_symbols = TRUE, split_hyphens = TRUE, remove_separators = TRUE)
tok2 <- tokens_remove(tok2, stopwords("en"))
tok2 <- tokens_wordstem (tok2)
myDfm <- dfm(tok2)

trimdfm <- dfm_trim(myDfm, min_termfreq = 10)

topfeatures(trimdfm, n=20, decreasing = TRUE)

set.seed(100)
textplot_wordcloud(trimdfm, min_count = 100, color = c('red', 'pink', 'green', 'purple', 'orange', 'blue'))
