
f_estimate_r <- function( df.data, variable  ) {
  cases <- df.data %>%
    arrange(date_reported) %>%
    filter(!! variable > 0) %>%
    pull(!! variable)
  
  result <- NA
  if (length(cases) > 7) {
    
    result <- suppressMessages(
      estimate_R(
        cases, method = "parametric_si", config = make_config(list(mean_si = si_mean, std_si = si_sd))
      )
    )
    
  }

  result
}

f_extract_r <- function( .m ) {
  .m$R
}