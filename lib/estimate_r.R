
require("EpiEstim")

f_estimate_r <- function( 
  df.data, cases_from, time_from, method="parametric_si", config = NULL, ...
) {
  
  cases_from <- enquo(cases_from)
  time_from <- enquo(time_from)
  
  if ( is.null(config)) {
    config <- make_config(...)
  }
  
  cases <- df.data %>%
    arrange(!!time_from) %>%
    trim.df( values_from = !!cases_from, value = 0, side = "both") %>%
    pull(!!cases_from)
  
  result <- NA
  if (length(cases) > 7) {
    
    result <- suppressMessages(
      estimate_R(
        cases, method = method, config = config
      )
    )
    
  }

  result
}

f_extract_r <- function( .d, .m, time_from ) {
  time_from <- enquo(time_from)
  
  results <- NA
  
  if (!is.na(.m)) {
    
    results <- .d %>%
      mutate(
        t_day = as.numeric(difftime(!!time_from, max(!!time_from), units="days"))
      ) %>%
      left_join(
        .m$R %>%
          mutate(
            t_day = t_end - max(t_end)
          ) %>%
          select(t_day, r_mean = `Mean(R)`, r_ci_lower = `Quantile.0.025(R)`, r_ci_upper = `Quantile.0.975(R)` ),
        by = "t_day"
      )
  }
  
  results
}