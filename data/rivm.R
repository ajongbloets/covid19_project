
require("readxl")

rivm.file.pattern <- "^(?:.*/)?([0-9]{8})_RIVM.xlsx?$"

collect_rivm_files <- function(path = NULL, pattern = NULL) {
  
  if (is.null(path)) {
    path <- file.path(data.dir, "rivm")
  }
  
  if (is.null(pattern)) {
    pattern <- rivm.file.pattern
  }
  
  list.files(
    path, pattern, full.names = TRUE
  )
  
}

load_rivm_file <- function( path, pattern) {
  
  dataset <- sub(pattern, "\\1", path)
  
  read_excel(path) %>%
    mutate(
      dataset = lubridate::ymd(dataset)
    )
  
}

load_rivm <- function( data.files = NULL, path = NULL, pattern = NULL, .most.recent = TRUE) {
  
  if (is.null(pattern)) {
    pattern <- rivm.file.pattern
  }
  
  if (is.null(data.files)) { 
    data.files <- collect_rivm_files(path = path, pattern = pattern)  
  }
  
  results <- map_dfr(
    data.files, load_rivm_file, pattern=pattern
  )
  
  if (.most.recent) {
    
    results %>%
      filter(dataset == max(dataset))
    
  }
  
  return(results)
  
}

summarise_rivm <- function( df.data = NULL ) {
  
  if (is.null(df.data)) {
    
    df.data <- load_rivm()
    
  }
  
  df.data %>%
    group_by(date_reported, add = T) %>%
    summarise(
      new_cases = sum(new_cases),
      new_deaths = sum(new_deaths),
      new_hospital = sum(new_hospital)
    )
  
}