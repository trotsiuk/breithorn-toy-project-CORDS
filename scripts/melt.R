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

