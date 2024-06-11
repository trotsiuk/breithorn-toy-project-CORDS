# src/utils.R
library(git2r)

make_sha_filename <- function(basename, ext) {
  # Open the git-repository in the current directory
  repo <- repository(".")
  
  # Get the object ID of the HEAD commit
  head_commit <- revparse_single(repo, "HEAD")
  short_hash <- substr(head_commit$sha, 1, 10)
  
  # Check if there are uncommitted changes
  status <- status(repo)
  is_dirty <- length(status$staged) > 0 || length(status$unstaged) > 0 || length(status$untracked) > 0
  
  # Append "-dirty" if there are uncommitted changes
  if (is_dirty) {
    postfix <- paste0(short_hash, "-dirty")
  } else {
    postfix <- short_hash
  }
  
  return(paste0(basename, "-", format(Sys.Date(), format = "%Y%m%d"), "-", postfix, ".", ext))
}



# Example usage:
# download_file("http://example.com/file.txt", "path/to/destination/file.txt")
download_file <- function(url, destination_file) {
  # Ensure necessary package is loaded
  library(httr)
  
  # Create directory if it doesn't exist
  dir.create(dirname(destination_file), recursive = TRUE, showWarnings = FALSE)
  
  if (file.exists(destination_file)) {
    # Do nothing
    message("Already downloaded ", destination_file)
  } else {
    # Download the file
    message("Downloading ", destination_file, " ... ")
    GET(url, write_disk(destination_file, overwrite = TRUE))
    message("done.")
  }
  
  return(invisible(NULL))
}


# Example usage:
# unzip_one_file("path/to/zipfile.zip", "file_inside_zip.txt", "path/to/destination/file.txt")

unzip_one_file <- function(zipfile, filename, destination_file) {
  
  # Create directory if it doesn't exist
  dir.create(dirname(destination_file), recursive = TRUE, showWarnings = FALSE)
  
  # Read the zip file
  zip_contents <- utils::unzip(zipfile, list = TRUE)
  
  # Check if the specific file exists in the zip archive
  if (filename %in% zip_contents$Name) {
    # Extract the specific file
    utils::unzip(zipfile, files = filename, exdir = dirname(destination_file))
    
    # Rename the extracted file to the destination file
    file.rename(file.path(dirname(destination_file), filename), destination_file)
  } else {
    message("File ", filename, " not found in the zip archive.")
  }
  
  return(invisible(NULL))
}


read_data <- function(weather_fl, dem_fl, mask_fl, Ps0) {
  # Placeholder for actual implementation of read_campbell function
  t <- seq.Date(from = as.Date("2000-01-01"), by = "day", length.out = 365)
  Ts <- runif(365, -10, 10)  # Placeholder for actual temperature data
  Ps <- rep(Ps0, length(Ts))  # Make precipitation a vector of the same length as Ts
  z_weather_station <- 1500  # Placeholder for actual elevation data
  dem <- raster::raster(dem_fl)
  mask <- raster::raster(mask_fl)
  return(list(t = t, Ts = Ts, dem = dem, Ps = Ps, z_weather_station = z_weather_station)) #mask = mask, 
}


visualize_data <- function(t, Ts,  dem, results_dir) { #mask,
  plot_filename <- make_sha_filename(file.path(results_dir, "breithorn_T"), "png")
  png(plot_filename)
  plot(t, Ts, type = "l", xlab = "time (d)", ylab = "T (C)")
  dev.off()
  
  # mask_plot_filename <- make_sha_filename(file.path(results_dir, "breithorn_mask"), "png")
  # png(mask_plot_filename)
  # plot(mask)
  # dev.off()
  
  dem_plot_filename <- make_sha_filename(file.path(results_dir, "breithorn_dem"), "png")
  png(dem_plot_filename)
  plot(dem)
  dev.off()
}



glacier_net_balance_fn <- function(zs, dt, Ts, Ps, melt_factor, T_threshold, lapse_rate) {
  # Placeholder for actual implementation
  net_balance <- runif(length(zs), -10, 10)  # Placeholder for net balance calculation
  glacier_net_balance <- sum(net_balance) * dt  # Placeholder for glacier net balance calculation
  return(list(glacier_net_balance = glacier_net_balance, net_balance = net_balance))
}

# Function to run model for the whole glacier
run_model_for_glacier <- function(dem, Ts, Ps, melt_factor, T_threshold, lapse_rate, z_weather_station, results_dir) {
  zs <- dem - z_weather_station
  dt <- diff(t)[1]
  
  result <- glacier_net_balance_fn(zs, dt, Ts, Ps, melt_factor, T_threshold, lapse_rate)
  glacier_net_balance <- result$glacier_net_balance
  net_balance <- result$net_balance
  
  net_balance_df <- data.frame(z = zs, net_balance = net_balance)
  net_balance_map <- rasterFromXYZ(net_balance_df)
  
  net_balance_plot_filename <- make_sha_filename(file.path(results_dir, "breithorn_net_balance_field"), "png")
  png(net_balance_plot_filename)
  plot(net_balance_map)
  dev.off()
  
  return(list(zs = zs, dt = dt))
}

