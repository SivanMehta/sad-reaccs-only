# assuming that the loading in most-common.R is already run

common.words %>%
  inner_join(get_sentiments("afinn")) %>%
  group_by(post_id, reaction) %>% 
  summarise(post_score = sum(score)) %>%
  ggplot(aes(x = post_score)) +
    geom_histogram() + 
    facet_wrap(~ reaction)
