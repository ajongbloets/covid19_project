
cw.file.pattern <- "^(?:.*/)?rivm_NL_covid19_national_by_date_([0-9]{4}-[0-9]{2}-[0-9]{2})\\.csv?$"

collect_cw_files <- function(path = NULL, pattern = NULL) {
  
  if (is.null(path)) {
    path <- file.path(data.dir, "cw")
  }
  
  if (is.null(pattern)) {
    pattern <- cw.file.pattern
  }
  
  results <- tibble(
    path = list.files(
      path, pattern, full.names = TRUE
    ),
    pattern = pattern
  )
  
  return(results)
}

read_cw_file <- function( path, pattern=NULL) {
  
  report_date <- lubridate::ymd(sub(cw.file.pattern, "\\1", path))
  
  read_csv(path) %>%
    rename(
      date = Datum, metric = Type, new_counts = Aantal
    ) %>%
    mutate(
      metric = ifelse( metric == "Totaal", "cases", metric),
      metric = ifelse( metric == "Ziekenhuisopname", "hospital", metric),
      metric = ifelse( metric == "Overleden", "deaths", metric)
    ) %>%
    group_by(metric) %>%
    mutate(
      report_date = report_date
    )
  
}

load_cw <- function( df.files = NULL, path = NULL, pattern = NULL) {
  
  if (is.null(pattern)) {
    pattern <- cw.file.pattern
  }
  
  if (is.null(df.files)) { 
    df.files <- collect_cw_files(path = path, pattern = pattern)  
  }
  
  results <- df.files %>%
    mutate(
      data = map(path, read_cw_file, pattern=pattern)
    ) %>%
    unnest(data) %>%
    select(-c(path, pattern)) %>%
    arrange(report_date, date)
  
  return(results)
  
}
