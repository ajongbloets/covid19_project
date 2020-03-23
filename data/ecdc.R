
require("readxl")

ecdc.file.pattern <- "^(?:.*/)?([0-9]{8})_ECDC.xlsx?$"

collect_ecdc_files <- function(path = NULL, pattern = NULL) {
  
  if (is.null(path)) {
    path <- file.path(data.dir, "ecdc")
  }
  
  if (is.null(pattern)) {
    pattern <- ecdc.file.pattern
  }
  
  list.files(
    path, pattern, full.names = TRUE
  )
  
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

load_ecdc_file <- function( path, pattern) {
  
  dataset <- sub(pattern, "\\1", path)
  
  read_excel(path) %>%
    select(
      date_reported = 1, new_cases = 5, new_deaths = 6, country = 7, geo_id = 8
    ) %>%
    mutate(
      dataset = lubridate::ymd(dataset)
    ) %>%
    filter(
      new_cases >= 0, new_deaths >= 0
    )
  
}

load_ecdc <- function( data.files = NULL, path = NULL, pattern = NULL, .most.recent = TRUE) {
  
  if (is.null(pattern)) {
    pattern <- ecdc.file.pattern
  }
  
  if (is.null(data.files)) { 
    data.files <- collect_ecdc_files(path = path, pattern = pattern)  
  }
  
  results <- map_dfr(
    data.files, load_ecdc_file, pattern=pattern
  )
  
  if (.most.recent) {
    
    results %>%
      filter(dataset == max(dataset))
    
  }
  
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