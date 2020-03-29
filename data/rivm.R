
require("readxl")

rivm.file.pattern <- "^(?:.*/)?([0-9]{8})_RIVM.xlsx?$"

collect_rivm_files <- function(path = NULL, pattern = NULL) {
  
  if (is.null(path)) {
    path <- file.path(data.dir, "rivm")
  }
  
  if (is.null(pattern)) {
    pattern <- rivm.file.pattern
  }
  
  results <- tibble(
    path = list.files(
      path, pattern, full.names = TRUE
    ),
    pattern = pattern
  ) %>%
    mutate(
      dataset = lubridate::ymd(sub(pattern, "\\1", path))
    )
  
  return(results)
}

load_rivm_file <- function(path, pattern=NULL) {
  
  read_excel(path)
  
}

load_rivm <- function( df.files = NULL, path = NULL, pattern = NULL, .most.recent = TRUE) {
  
  if (is.null(pattern)) {
    pattern <- rivm.file.pattern
  }
  
  if (is.null(df.files)) { 
    df.files <- collect_rivm_files(path = path, pattern = pattern)  
  }
  
  if (.most.recent) {
    df.files <- df.files %>%
      filter(dataset == max(dataset))
  }
  
  results <- df.files %>%
    mutate(
      data = map2(path, pattern, load_rivm_file)
    ) %>%
    unnest(data) %>%
    select(-c(path, pattern, dataset)) %>%
    pivot_longer(
      cols = starts_with("new_"),
      names_to = "metric",
      names_prefix = "new_",
      values_to = "value"
    )
  
  return(results)
  
}

summarise_rivm <- function( df.data ) {
  
  df.data %>%
    group_by(date_reported, add = T) %>%
    summarise(
      new_cases = sum(new_cases),
      new_deaths = sum(new_deaths),
      new_hospital = sum(new_hospital)
    )
  
}