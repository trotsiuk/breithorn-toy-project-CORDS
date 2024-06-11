
# Libraries ---------------------------------------------------------------

library(dplyr)
library(ggplot2)
library(breithornToyProjectCORDS)

source("src/utils.R")




# T09 example -------------------------------------------------------------
# Example usage of make_sha_filename to store tables and plots
filename <- make_sha_filename("results/table", "csv")
cat("Generated filename:", filename, "\n")

# Save a table to the generated filename
example_data <- data.frame(x = 1:10, y = rnorm(10))
write.csv(example_data, filename)

# Save a plot to the generated filename
plot_filename <- make_sha_filename("results/plot", "png")

ggplot(example_data, aes(x, y)) +
  geom_point()

ggsave(plot_filename)
