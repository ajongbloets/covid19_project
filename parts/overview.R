
main.summary <- htmlOutput("summary")

main.overview.tab <- tabPanel(
  "Overview",
  h3("New Cases"),
  plotOutput(
    "plot.overview.new",
    # dblclick = "plot1_dblclick",
    # brush = brushOpts(
    #   id = "plot1_brush",
    #   resetOnNew = TRUE, direction = "x"
    # )
  ),
  h3("Cumulative Cases"),
  plotOutput(
    "plot.overview.cum", 
  ),
  h3("Estimated R"),
  plotOutput(
    "plot.overview.r"
  )
)
