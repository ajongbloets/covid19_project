
nice.file.pattern <- "^(?:.*/)?([0-9]{8})_nice_ic_by_day\\.csv?$"

collect_nice_files <- function(path = NULL, pattern = NULL) {
  
  if (is.null(path)) {
    path <- file.path(data.dir, "nice")
  }
  
  if (is.null(pattern)) {
    pattern <- nice.file.pattern
  }
  
  results <- tibble(
    path = list.files(
      path, pattern, full.names = TRUE
    ),
    pattern = pattern
  )
  
  return(results)
}

read_nice_file <- function( path, pattern=NULL) {
  
  report_date <- lubridate::ymd(sub(nice.file.pattern, "\\1", path))
  
  result <- read_csv(path)
  
  if ("Datum" %in% colnames(result)) {
    result <- result %>% rename(date = Datum)
  }
  
  result %>%
    arrange(date) %>%
    mutate(
      new_deaths = diedCumulative - lag(diedCumulative, default=0),
      new_survived = survivedCumulative - lag(survivedCumulative, default=0)
    ) %>%
    select(
      date,
      new_intake = newIntake,
      new_deaths,
      new_survived
    ) %>%
    pivot_longer(
      cols = -c(date),
      names_to = "metric",
      names_prefix = "new_",
      values_to = "new_counts"
    ) %>%
    group_by(metric) %>%
    mutate(
      report_date = report_date
    )
  
}

load_nice <- function( df.files = NULL, path = NULL, pattern = NULL) {
  
  if (is.null(pattern)) {
    pattern <- nice.file.pattern
  }
  
  if (is.null(df.files)) { 
    df.files <- collect_nice_files(path = path, pattern = pattern)  
  }
  
  results <- df.files %>%
    mutate(
      data = map(path, read_nice_file, pattern=pattern)
    ) %>%
    unnest(data) %>%
    select(-c(path, pattern)) %>%
    arrange(report_date, date)
  
  return(results)
  
}
