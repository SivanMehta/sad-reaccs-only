# do something along these lines:
# http://tidytextmining.com/nasa.html#word-co-ocurrences-and-correlations
# to find words that appear together

library(dplyr)
library(widyr)

pairs <- common.words %>%
  pairwise_count(word, post_id, sort = TRUE, upper = FALSE) %>%
  filter(n > 5) %>%
  mutate(pair = paste(item1, item2, sep = "+"))

pairs %>% 
  ggplot(aes(reorder(pair, n), n)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Most common pairs of words in NYT Articles",
    subtitle = paste("Last", nrow(dat) ,"articles pulled, stop words removed"),
    y = "# of pairs"
  )
