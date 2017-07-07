# graph the most common ones
common.words %>%
  count(word, sort = TRUE) %>%
  head(25) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
    geom_col() +
    coord_flip() +
    labs(title = "Most common words in New York Times Articles",
         subtitle = paste("Last", nrow(dat) ,"articles pulled, stop words removed"),
         y = "# of uses")
