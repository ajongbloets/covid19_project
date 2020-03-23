
f_estimate_r <- function( df.data, variable, si_mean = 5, si_sd = 3.4  ) {
  variable <- enquo(variable)
  
  cases <- df.data %>%
    arrange(date_reported) %>%
    filter(!!variable > 0) %>%
    pull(!!variable)
  
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
  result <- NA
  if (!is.na(.m)) {
    result <- .m$R %>%
      mutate(
        t_day = t_end - max(t_end)
      )
  }
  
  result
}