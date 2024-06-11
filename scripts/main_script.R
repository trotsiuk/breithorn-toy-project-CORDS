# renv::restore()

# Libraries ---------------------------------------------------------------
library(ggplot2)
library(breithornToyProjectCORDS)

source("src/utils.R")

# Run the simple example --------------------------------------------------
## Define the synthetic weather and glacier
synthetic_T <- function(t){
  return(-10*cos(2*pi/365 * t) - 8*cos(2*pi* t) + 5 )
}

synthetic_Pfunction <- function(t){
  return(rep(8e-3, length(t))) # precip in m/day
}

synthetic_glacier <- function(){
  x <- seq(0,5000,500) #0:500:5000
  elevation = x/5  + 1400
  return(list(x, elevation))
}

## Define constants
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
write.csv(example_data, filename)

# Save a plot to the generated filename
plot_filename <- make_sha_filename("results/plot", "png")

ggplot(example_data, aes(x, y)) +
  geom_point()

ggsave(plot_filename)



# T13 Real example --------------------------------------------------------

# Set up results directory
results_dir <- "results/"
data_own_dir <- 'data/own/'
data_foreign_dir <- 'data/foreign/'

for( d in c(results_dir, data_own_dir, data_foreign_dir)){
  if(!dir.exists(d)) dir.create( d, recursive = T )
}

# Download data
weather_fl <- "data/own/weather.dat"

if (!file.exists(weather_fl)) {
  weather_url <- "https://raw.githubusercontent.com/mauro3/CORDS/master/data/weather.dat"
  info_url <- "https://raw.githubusercontent.com/mauro3/CORDS/master/data/weather.info"
  weather_info_fl <- 'data/own/weather.info'
  
  message("Downloading weather data...")
  download_file(weather_url, weather_fl)
  download_file(info_url, weather_info_fl)
}


dem_fl <- 'data/foreign/dhm200.asc'
if (!file.exists(dem_fl)) {
  dem_url <- "https://github.com/mauro3/CORDS/raw/master/data/workshop-reproducible-research/foreign/swisstopo_dhm200_cropped.zip"
  zip_path <- 'data/foreign/dhm200.zip'
  
  message("Downloading DEM data...")
  download_file(dem_url, zip_path)
  
  # Extract specific file from zip
  message("Extracting DEM data...")
  unzip_one_file(zip_path, "swisstopo_dhm200_cropped/dhm200_cropped.asc", dem_fl)
  file.remove(zip_path)
}


mask_fl <- 'data/own/glacier_mask.asc'
if (!file.exists(mask_fl)) {
  mask_url <- "https://github.com/mauro3/CORDS/raw/master/data/workshop-reproducible-research/own/mask_breithorngletscher.zip"
  zip_path <- 'data/own/mask_breithorngletscher.zip'
  
  message("Downloading Masc data...")
  download_file(mask_url, zip_path)
  
  # Extract specific file from zip
  message("Extracting Masc data...")
  unzip_one_file(zip_path, "mask_breithorngletscher/mask_breithorngletscher.asc", mask_fl)
  file.remove(zip_path)
  
  
}


PARAMS <- list(
  lapse_rate = -0.6 / 100,
  melt_factor = 0.005,
  T_threshold = 4
)

# Read data and visualize it (Placeholder for future implementation)
weather_fl <- "own/weather.dat"
mask_fl <- "data/own/glacier_mask.asc"
dem_fl <- 'data/foreign/dhm200.asc'
Ps0 <- 0.005  # Mean (and constant) precipitation rate [m/d]

# Read data
data <- read_data(weather_fl, dem_fl, mask_fl, Ps0)
t <- data$t
Ts <- data$Ts
dem <- data$dem
mask <- data$mask
Ps <- data$Ps
z_weather_station <- data$z_weather_station

# Visualize data
visualize_data(t, Ts, dem, mask, results_dir) # 

# Run model for the whole glacier
model_results <- run_model_for_glacier(dem, mask, Ts, Ps, PARAMS$melt_factor, PARAMS$T_threshold, PARAMS$lapse_rate, z_weather_station, results_dir)
zs <- model_results$zs
dt <- model_results$dt

# Generate output table
generate_output_table(zs, dt, Ts, Ps, PARAMS$melt_factor, PARAMS$T_threshold, PARAMS$lapse_rate, results_dir)
