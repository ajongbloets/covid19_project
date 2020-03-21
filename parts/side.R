
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

side.si.parameters <- p(
  sliderInput(
    "si_mean",
    "Average Incubation Time (days)",
    min = 0, max = 14, step = 0.1,
    value = 5
  ),
  sliderInput(
    "si_sd",
    "St.Dev. Incubation Time (days)",
    min = 0, max = 14, step = 0.1,
    value = 3.4
  )
)

side.select.view <- p(
  selectInput(
    "data.view", 
    "Select what to show:",
    choices = c("Global", "European", "Countries"),
    selected = "Global",
    multiple = FALSE
  )
)

side.select.territory <- p(
  selectInput(
    "territory", 
    "Select Countries to show:",
    choices = unique(df.ecdc$country),
    selected = "Netherlands",
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