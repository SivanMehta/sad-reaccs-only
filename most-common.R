library(tidyverse)
library(tidytext)
library(lubridate)
library(stringr)
library(ggplot2)

# read in data
library(readr)
data <- read_csv("data/2017-06-20.csv")

# remove escaped characters
data$text <- gsub("%20", " ", data$text)
data$text <- gsub("%22", "'", data$text)
data$text <- gsub("%27", "'", data$text)
data$text <- gsub("%2C", ",", data$text)
data$text <- gsub("%3A", ":", data$text)
data$text <- gsub('%3F', "", data$text)
data$text <- gsub('201', "", data$text)
data$text <- gsub('2019s', "", data$text)
data$text <- gsub('2014', "", data$text)

nyt_stop_words <- tibble(
  word = c('new', 'york', 'times', 'opinion', 'section', 'http', 'breaking', 'news', 'nyti.ms'),
  lexicon = 'NYT'
)

# generate dataframe of each distinct word
common.words <- data %>%
  arrange(text) %>%
  unnest_tokens(word, text, drop = FALSE) %>%
  distinct(post_id, word, .keep_all = TRUE) %>%
  anti_join(stop_words, by = "word") %>%
  anti_join(nyt_stop_words, by = "word") %>%
  filter(str_detect(word, "[^\\d]")) %>%
  filter(nchar(word) > 3) %>%
  group_by(word) %>%
  mutate(word_total = n()) %>%
  ungroup()

# graph the most common ones
common.words %>%
  count(word, sort = TRUE) %>%
  head(25) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
    geom_col() +
    coord_flip() +
    labs(title = "Most common words in New York Times Articles",
         subtitle = "Last 100 articles pulled, stop words removed",
         y = "# of uses")

