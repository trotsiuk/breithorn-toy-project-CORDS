# Libraries ---------------------------------------------------------------
library(ggplot2)
library(breithornToyProjectCORDS)

source("src/utils.R")

# Run the simple example --------------------------------------------------


# Define the data ---------------------------------------------------------
lapse_rate = -0.6/100
melt_factor = 0.005
T_threshold = 4
dt = 1/24
t = 0:dt:365

## Plot the synthetic weather
Ts = synthetic_T(t)
plot(Ts)
# ggplot(data.frame(Ts), aes(x=))

## Run the model for one year at a point
ele = 1500
Ts_ele = calculate_lapsed_temperature(
  elevation = 1500, 
  elevation_station = 0, 
  temperature_station = Ts, 
  lapse_rate = lapse_rate)
Ps = synthetic_Pfunction(t)
length(Ts_ele)
length(Ps)

breithornToyProjectCORDS::net_balance_fn(dt = dt, Ts = Ts_ele, Ps = Ps,
                                         melt_factor = melt_factor, 
                                         T_threshold = T_threshold)
##### total_point_balance(...)

## Run the model for one year for the whole glacier
res = synthetic_glacier()
xs = res[[1]]
zs = res[[2]]

res <- glacier_net_balance_fn(zs, dt, Ts, Ps, melt_factor, T_threshold, lapse_rate)
total_massbalance <- res[[1]]
point_massbalance <- res[[2]]


# plot(xs, point_massbalance)

## Generate output table
# make a table of mass-balance for different temperature offsets and store it
out = list()
for (dT in -4:4){
  Ts_ = synthetic_T(t) + dT
  # run model
  res <- glacier_net_balance_fn(zs, dt, Ts, Ps, melt_factor, T_threshold, lapse_rate)
  # store in out
  out <- rbind(out, data.frame(dT = dT, zs, res[1], res[2]))
}




# T09 example -------------------------------------------------------------
# Example usage of make_sha_filename to store tables and plots
filename <- make_sha_filename("results/table", "csv")
cat("Generated filename:", filename, "\n")

# Save a table to the generated filename
example_data <- data.frame(x = 1:10, y = rnorm(10))
# write.csv(example_data, filename)

# Save a plot to the generated filename
plot_filename <- make_sha_filename("results/plot", "png")

ggplot(example_data, aes(x, y)) +
  geom_point()

# ggsave(plot_filename)
