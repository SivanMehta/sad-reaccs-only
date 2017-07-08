# assuming that the loading in most-common.R is already run
post.scores <- common.words %>%
  inner_join(get_sentiments("afinn")) %>%
  group_by(post_id, reaction) %>% 
  summarize(post.score = sum(score), sentiment = mean(sentiment))

# histogram for each dominant reaction
post.scores %>%
  ggplot(aes(x = post_score)) +
    geom_histogram() + 
    facet_wrap(~ reaction)

# scatterplot of sentiment vs like proportion
post.scores %>%
  right_join(dat) %>%
  mutate(like.proportion = LIKE / (LIKE + HAHA + SAD + LOVE + ANGRY + WOW + PRIDE)) %>%
  ggplot(aes(x = like.proportion, y = post.score)) +
    geom_point() +
    labs(
      title = "Proportion of Likes vs. Sentiment score",
      subtitle = paste("Last", nrow(dat) ,"articles pulled, stop words removed"),
      x = "Proportion of Likes",
      y = "Sentiment"
    )

# scatter plot of by-word sentiment vs. sentimentr analysis
post.scores %>%
  right_join(dat) %>%
  mutate(like.proportion = LIKE / (LIKE + HAHA + SAD + LOVE + ANGRY + WOW + PRIDE)) %>%
  ggplot() +
  aes(x = post.score, y = sentiment, fill = like.proportion) +
  geom_point() + geom_smooth()
