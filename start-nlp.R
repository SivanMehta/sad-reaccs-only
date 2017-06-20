library(tidyverse)
library(lubridate)
library(readr)
library(tidytext)
library(stringr)
library(ggplot2)

# read in data
data <- read_delim("data/2017-06-20.csv", "\t", escape_double = FALSE, trim_ws = TRUE)

# remove escaped characters
data$text <- gsub("%20", " ", data$text)
data$text <- gsub("%3A", ":", data$text)
data$text <- gsub("%2C", ",", data$text)
data$text <- gsub("%22", "'", data$text)
data$text <- gsub("%27", "'", data$text)

common.words <- data %>%
  arrange(text) %>%
  unnest_tokens(word, text, drop = FALSE) %>%
  distinct(post_id, word, .keep_all = TRUE) %>%
  anti_join(stop_words, by = "word") %>%
  filter(str_detect(word, "[^\\d]")) %>%
  group_by(word) %>%
  mutate(word_total = n()) %>%
  ungroup()

word_counts <- common.words %>%
  count(word, sort = TRUE)

word_counts %>%
  head(25) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col(fill = "lightblue") +
  coord_flip() +
  labs(title = "Most common words in New York Times Articles",
       subtitle = "Last 100 articles pulled",
       y = "# of uses")
