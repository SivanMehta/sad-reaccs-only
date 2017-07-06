# do something along these lines:
# http://tidytextmining.com/nasa.html#word-co-ocurrences-and-correlations
# to find words that appear together

library(dplyr)
library(widyr)
library(ggraph)
library(igraph)

# tibble of pairs and their frequencies
num.pairs <- common.words %>%
  pairwise_count(word, post_id, sort = TRUE, upper = FALSE) %>%
  mutate(pair = paste(item1, item2, sep = "+"))

# plot of most common pairs
num.pairs %>%
  filter(n > 3) %>%
  ggplot(aes(x = reorder(pair, n), y = n)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Most common pairs of words in NYT Articles",
    subtitle = paste("Last", nrow(dat) ,"articles pulled, stop words removed"),
    y = "# of pairs")

# network graph of pairs weighted by commonality
set.seed(1)
num.pairs %>%
  filter(n > 3) %>%
  graph_from_data_frame() %>%
  ggraph(layout = "kk") +
  geom_edge_link(aes(edge_alpha = n, edge_width = 2), edge_colour = "cyan4") +
  geom_node_point(size = 2) +
  geom_node_text(aes(label = name), repel = TRUE, 
                 point.padding = unit(0.2, "lines")) +
  theme_void()
