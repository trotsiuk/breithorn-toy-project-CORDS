# renv::restore()

# Libraries ---------------------------------------------------------------
library(ggplot2)
library(breithornToyProjectCORDS)

source("src/utils.R")


# T13 Real example --------------------------------------------------------

results_dir <- "results/"
data_own_dir <- 'data/own/'
data_foreign_dir <- 'data/foreign/'

for( d in c(results_dir, data_own_dir, data_foreign_dir)){
  if(!dir.exists(d)) dir.create( d, recursive = T )
}


# Downloading the data ----------------------------------------------------

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



# Setting the parameters --------------------------------------------------


PARAMS <- list(
  lapse_rate = -0.6 / 100,
  melt_factor = 0.005,
  T_threshold = 4
)


# Running the model -------------------------------------------------------


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
