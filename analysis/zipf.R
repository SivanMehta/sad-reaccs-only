# http://tidytextmining.com/tfidf.html#zipfs-law

library(dplyr)
library(tidytext)

post.words <- common.words %>%
  unnest_tokens(word, word) %>%
  count(reaction, word, sort = TRUE) %>%
  ungroup()

total.words <- post.words %>% 
  group_by(reaction) %>% 
  summarize(total = sum(n))

post.words <- left_join(post.words, total.words)

freq_by_rank <- post.words %>% 
  group_by(reaction) %>% 
  mutate(rank = row_number(), 
         `term frequency` = n/total)

freq_by_rank %>% 
  ggplot(aes(rank, `term frequency`, color = reaction)) + 
  geom_line(size = 1.2, alpha = 0.8) + 
  scale_x_log10() +
  scale_y_log10() +
  labs(x = "Rank", y = "Term Frequency", title = "Zipf's Distribution")
