

trim.df <- function( df.data, values_from, value, side = "left", .index_name = "i" ) {
  
  values_from <- enquo(values_from)

  stopifnot(side %in% c("left", "right", "both"))
  
  # trim both sides means do left and right separately
  if (side == "both") {
    
    return(
      df.data %>%
        trim.df( !!values_from, value, side = "left", .index_name = .index_name) %>%
        trim.df( !!values_from, value, side = "right", .index_name = .index_name)
    )
    
  }
  
  indexes <- df.data %>%
    mutate(
      !!.index_name := row_number()
    ) %>%
    filter(
      (!!values_from) != !!value
    ) %>%
    pull(!!.index_name)
  
  results <- switch (side,
    "left" = df.data %>%
      filter(row_number() >= min(indexes)),
    "right" = df.data %>%
      filter(row_number() <= max(indexes))
  )
  
  
  return(results)
}