
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

source(file.path(shiny.parts.dir, "side.R"))
source(file.path(shiny.parts.dir, "overview.R"))

shinyUI(fluidPage(
  
  # Application title
  titlePanel("COVID-19 Dashboard"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      side.show.variable,
      hr(),
      side.select.territory,
      side.summarise.data,
      hr(),
      side.remove.zero,
      side.scale.log,
      hr(),
      p(
        uiOutput("version")
      )
    ),
    mainPanel(
      main.summary,
      main.overview.tab
    ) # end of side bar panel
  ) # end of side bar layout
))
