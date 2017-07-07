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

# network graph of pairs weighted by commonality
set.seed(1)
num.pairs %>%
  filter(n > 3) %>%
  graph_from_data_frame() %>%
  ggraph(layout = "kk") +
  geom_edge_link(aes(edge_alpha = n, edge_width = 2)) +
  geom_node_point(size = 2) +
  geom_node_text(aes(label = name), repel = TRUE, 
                 point.padding = unit(0.2, "lines")) +
  theme_graph()

# plot of most common pairs
num.pairs %>%
  filter(n > 3) %>%
  ggplot(aes(x = reorder(pair, n), y = n)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Most common pairs of words in NYT headlines",
    subtitle = paste("Last", nrow(dat) ,"articles pulled, stop words removed"),
    y = "# of pairs")

# OK lets cut straight to the chase, what about the Donald?
num.pairs %>% 
  filter(item1 == "trump" | item2 == "trump") %>%
  filter(n > 2) %>%
  arrange(-n) %>%
  ggplot(aes(x = reorder(pair, n), y = n)) +
  geom_col() + coord_flip() +
  labs(
    title = "Words most commonly paired with \"Trump\" in NYT headlines",
    subtitle = paste("Last", nrow(dat) ,"articles pulled, stop words removed"),
    y = "# of pairs")
