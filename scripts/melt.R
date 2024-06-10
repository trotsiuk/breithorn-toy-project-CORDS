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


calculate_precip <- function( t ) {
  #' @description generate synthetic precipitation data (m/day)
  #' @param t time in days since beginning of simulation (currently deactivated)
  #' @example calculate_precip(t = 5)
  
  out <- 8e-3 # m/day
  
  return( out )
}
