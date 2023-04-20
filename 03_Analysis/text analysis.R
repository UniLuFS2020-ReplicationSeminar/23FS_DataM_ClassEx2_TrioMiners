#install.packages("ggExtra")
library(here)
library(tidyverse)
library(quanteda)
library(SentimentAnalysis)
library(ggExtra)


### sentiment analysis

#load data
load(here("AI_dfm_guardian.RData"))


# accessing articles and dates in the dfm / convert date variable

articles <- trimdfm@docvars$V3 # note the unusual indexing with @!

dates <- trimdfm@docvars$V1

df_ai <- data.frame(dates, articles)

df_ai <- df_ai %>% 
  mutate(dates = substr(dates, 1, 10)) %>% 
  mutate(dates = as.Date(dates))
  
# check class of dates
class(df_ai$dates[1])



# load LSD dictionary from quanteda package
LSD_dict <- SentimentDictionaryBinary(data_dictionary_LSD2015$positive, data_dictionary_LSD2015$negative)


# analyze headline sentiment using LSD dictionary (using SentimentAnalysis package)
sentiment <- analyzeSentiment(df_ai$articles, removeStopwords = T, stemming = T,
                              rules=list("Sentiment"=list(ruleSentimentPolarity, # Sentiment score defined as the difference between positive and negative word counts divided by the sum of positive and negative words.
                                                          LSD_dict)))

# add sentinemt to df
df_ai <- data.frame(df_ai, sentiment)


# add column to show week number
df_ai$week_num <- strftime(df_ai$dates, format = "%V")


# group by week and calculate mean of sentiment score
mean_sentiment <- df_ai %>% 
  group_by(week_num) %>% 
  summarise(mean_sent = mean(Sentiment, na.rm = T))


# order weeks correctly
mean_sentiment$week_num <- as.numeric(mean_sentiment$week_num)
class(mean_sentiment$week_num[1])

mean_sentiment$week_num <- factor(mean_sentiment$week_num,levels = c(seq(35,52), seq(1,16)))


# plot sentiment over time
ggplot(mean_sentiment) +
  geom_col(mapping = aes(x=week_num,y=mean_sent), fill = "steelblue") +
  labs(title = "Sentiment of Coverage about AI from September 2022 to April 2023",
       x = "Week code",
       y = "Sentiment Score")


### frequency analysis

# count articles over time (order weeks correctly in a first step)
df_ai$week_num <- as.numeric(df_ai$week_num)
df_ai$week_num <- factor(df_ai$week_num,levels = c(seq(35,52), seq(1,16)))

table_count <- table(df_ai$week_num)

# plot number of articles over time
plotCount(table_count, fill = "steelblue") +
  labs(title = "Frequency of Coverage about AI from September 2022 to April 2023",
       x = "Week code",
       y = "Number of Articles")












                              