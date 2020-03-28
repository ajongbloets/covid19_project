
require("readxl")

ecdc.file.pattern <- "^(?:.*/)?([0-9]{8})_ECDC.xlsx?$"

collect_ecdc_files <- function(path = NULL, pattern = NULL) {
  
  if (is.null(path)) {
    path <- file.path(data.dir, "ecdc")
  }
  
  if (is.null(pattern)) {
    pattern <- ecdc.file.pattern
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

download_ecdc_file <- function( .date = NULL ) {
  
  if (is.null(.date)) {
    .date <- Sys.Date()
  }
  
  url <- glue::glue(
    "https://www.ecdc.europa.eu/sites/default/files/documents/",
    'COVID-19-geographic-disbtribution-worldwide-{format(.date, "%Y-%m-%d")}.xlsx'
  )
  
  tmp <- tempfile(fileext = ".xlsx")
  
  try( httr::GET(url, authenticate(":", ":", type="ntlm"), write_disk(tmp)) )
}

load_ecdc_file <- function( path, pattern=NULL) {
  
  read_excel(path) %>%
    select(
      date_reported = 1, new_cases = 5, new_deaths = 6, country = 7, geo_id = 8, pop_size = 9
    ) %>%
    mutate(
      date_reported = lubridate::dmy(date_reported)
    ) %>%
    filter(
      new_cases >= 0, new_deaths >= 0
    )
  
}

load_ecdc <- function( df.files = NULL, path = NULL, pattern = NULL, .most.recent = TRUE) {
  
  if (is.null(pattern)) {
    pattern <- ecdc.file.pattern
  }
  
  if (is.null(df.files)) { 
    df.files <- collect_ecdc_files(path = path, pattern = pattern)  
  }
  
  if (.most.recent) {
    df.files <- df.files %>%
      filter(dataset == max(dataset))
  }
  
  results <- df.files %>%
    mutate(
      data = map(path, load_ecdc_file, pattern=pattern)
    ) %>%
    unnest(data) %>%
    select(-c(path, pattern, dataset))
  
  return(results)
  
}

summarise_ecdc <- function( df.data = NULL ) {
  
  if (is.null(df.data)) {
    
    df.data <- load_ecdc()
    
  }
  
  df.data %>%
    group_by(date_reported, add = T) %>%
    summarise(
      new_cases = sum(new_cases),
      new_deaths = sum(new_deaths)
    )
  
}