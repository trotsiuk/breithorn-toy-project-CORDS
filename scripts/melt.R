calculate_melt <- function( temperature, melt_factor ) {
  #' @description calculate the melting rate of the glacier (m/day)
  #' @param temperature average temperature
  #' @param melt_factro a melting factor (m/day/degree).
  #' @example calculate_melt(temperature = 5, melt_factor = 0.1)
  
  if (temperature >= 0) {
    
    out <- melt_factor * temperature
    
  } else {
    
    out <- 0
    
  }
  
  return( out )
}


calculate_accumulation <- function(temperature, precipitation, threshold_temperature) {
  #' @description Calculate accumulation at a point
  #'
  #' @param temperature Numeric. The temperature at the point of interest (in Celsius).
  #' @param precipitation Numeric. The precipitation amount (in mm or other units).
  #' @param threshold_temperature Numeric. The threshold temperature below which it snows (in Celsius).
  #'
  #' @return Numeric. The accumulation at the given point.
  #' @examples calculate_accumulation(temperature = -2, precipitation = 10, threshold_temperature = 0)
  
  
  if (temperature <= threshold_temperature) {
    
    return(precipitation)
    
  } else {
    
    return(0)
    
  }
}


calculate_lapsed_temperature <- function(elevation, elevation_station, temperature_station, lapse_rate) {
  #' @description Calculate lapsed temperature
  #'
  #' @param elevation Numeric. The elevation at the point of interest (in meters).
  #' @param elevation_station Numeric. The elevation of the weather station (in meters).
  #' @param temperature_station Numeric. The temperature at the weather station (in Celsius).
  #' @param lapse_rate Numeric. The lapse rate (in Celsius per meter).
  #'
  #' @return Numeric. The lapsed temperature at the given elevation.
  #' @examples
  #' calculate_lapsed_temperature(elevation = 1500, elevation_station = 1000, temperature_station = 10, lapse_rate = -0.0065)
  
  delta_z = elevation - elevation_station
  
  temperature = lapse_rate * delta_z + temperature_station
  
  return(temperature)
}


calculate_precip <- function( t ) {
  #' @description generate synthetic precipitation data (m/day)
  #' @param t time in days since beginning of simulation (currently deactivated)
  #' @example calculate_precip(t = 5)
  
  out <- 8e-3 # m/day
  
  return( out )
}
