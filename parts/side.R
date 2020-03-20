
side.data.source <- p(
  selectInput(
    inputId = "data.sources",
    label = "Select Data Source",
    choices = c()
  )
)

side.show.variable <- p(
  
  selectInput(
    "variable", 
    "Select Variable to show:",
    choices = c("Cases", "Deaths"),
    selected = c("Cases", "Deaths"),
    multiple = TRUE
  )
  
)

side.select.territory <- p(
  selectInput(
    "territory", 
    "Select Countries to show:",
    choices = c("Global", "European", unique(df.ecdc$country)),
    selected = "Global",
    multiple = TRUE
  )
)

side.summarise.data <- p(
  checkboxInput(
    "summarise.data",
    "Combine territories",
    value = FALSE
  )
)

side.remove.zero <- p(
  checkboxInput(
    "remove.zero",
    "Remove preceding zeros",
    value = FALSE
  )
)

side.scale.log <- p(
  checkboxInput(
   "scale.log",
   "Use Log10 scale",
   value = TRUE
  )
)