# read in data
library(readr)
source("./most-common.R")

# Let's characterize each post by the most common reaction that's not a like
data <- dat %>% mutate(sentiment = colnames(dat)[apply(dat, 1, which.max)])

a <- tibble(
  x <- runif(1000)
)

x <- runif(1000, 0.1, .3)
y <- log(1/x)
plot(x, y)
