rm(list = ls())
library(tidyverse)
library(tidytext)
library(lubridate)
library(stringr)
library(sentimentr)

# define dataset
dat <- data.frame(post_id = character(),
                  timestamp = character(), 
                  text = character(),
                  LIKE = integer(),
                  HAHA = integer(),
                  SAD = integer(),
                  LOVE = integer(),
                  ANGRY = integer(),
                  WOW = integer(),
                  PRIDE = integer())

# read in all data
library(readr)
for(fname in list.files("data/")) {
  filename <- paste("data/", fname, sep = "")
  imported <- as.data.frame(read_csv(filename))
  print(filename)
  dat <- rbind(dat, imported)
}

# remove escaped characters
dat$text <- gsub("%20", " ", dat$text)
dat$text <- gsub("%22", "'", dat$text)
dat$text <- gsub("%27", "'", dat$text)
dat$text <- gsub("%2C", ",", dat$text)
dat$text <- gsub("%3A", ":", dat$text)
dat$text <- gsub('%3F', "", dat$text)
dat$text <- gsub('201', "", dat$text)
dat$text <- gsub('2019s', "", dat$text)
dat$text <- gsub('2014', "", dat$text)

# add sentiment scores
dat <- dat %>% mutate(sentiment = syuzhet::get_sentiment(text))

nyt_stop_words <- tibble(
  word = c('new', 'york', 'times', 
           'opinion', 'section', 'http', 
           'breaking', 'news', 'nyti.ms',
           'comments', 'writers', 'live',
           'writes', 'questions', 'editorial',
           'times\'es',
           'week'), lexicon = 'NYT')

# generate datframe of each distinct word
common.words <- dat %>%
  mutate(reaction = colnames(dat)[apply(dat, 1, which.max)]) %>%
  unnest_tokens(word, text, drop = FALSE) %>%
  distinct(post_id, word, .keep_all = TRUE) %>%
  anti_join(stop_words, by = "word") %>%
  anti_join(nyt_stop_words, by = "word") %>%
  filter(nchar(word) > 3) %>%
  group_by(word) %>%
  mutate(word_total = n()) %>%
  ungroup() %>%
  select(word, post_id, reaction, sentiment)
