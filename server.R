
# Server logic of the cultivation app
# Here all the input is processed and output generated.
# Most of the tasks are delegated to functions from global.R
#
# Author: Joeri Jongbloets <j.a.jongbloets@uva.nl>
# Author: Hugo Pineda <hugo.pinedahernandez@student.uva.nl>
#

library(shiny)
library(knitr)

shinyServer(function(input, output, session) {
  
  # xlim <- reactive({
  #   input$ranges
  # })
  # 
  # xlim.zoom <- reactive({
  #   input$time.filter.zoom == TRUE
  # })

  
  ## Reactive variable selection
  plot.variable <- reactive({
    
    v <- input$variable
    
    validate(need(length(v) > 0, "Select a variable"))
    
    str_to_lower(v)
  })
  
  ## Reactive territory
  plot.territory <- reactive({
    
    v <- input$territory
    
    validate(need(length(v) > 0, "Select a territory"))
    
    v
  })
  
  
  ## Reactive od data
  df.data <- reactive({

    result <- data.frame()
    
    selected.territory <- plot.territory()
    
    result <- selected.territory %>%
      str_to_lower() %>%
      switch (
        "global" = df.ecdc,
        "european" = df.ecdc %>%
          filter(geo_id %in% european),
        df.ecdc %>%
          filter(country %in% selected.territory)
      )
    
    validate(need(nrow(result) > 0, "No data to show"))
    
    result
  })
  
  #
  #  Dynamic Elements
  #
  
  output$plot.overview.new <- renderPlot({
    
    d <- df.data()
    v <- plot.variable()
    
    d %>%
      summarise_ecdc %>%
      pivot_longer(
        cols = c(new_cases, new_deaths),
        names_to = "variable",
        names_prefix = "new_",
        values_to = "value"
      ) %>%
      filter( variable %in% v ) %>%
      ggplot(aes(x = date_reported, y = value, colour = variable)) +
      facet_wrap(~variable, scales = "free") +
      geom_line() +
      geom_point() +
      scale_y_log10() +
      labs(
        x = "Date",
        y = "Cases"
      )
    
  })
  
  output$plot.overview.cum <- renderPlot({
    
    d <- df.data()
    v <- plot.variable()
    
    d %>%
      summarise_ecdc %>%
      pivot_longer(
        cols = c(new_cases, new_deaths),
        names_to = "variable",
        names_prefix = "new_",
        values_to = "value"
      ) %>%
      group_by(variable) %>%
      mutate(
        cum_value = cumsum(value)
      ) %>%
      filter( variable %in% v ) %>%
      ggplot(aes(x = date_reported, y = cum_value, colour = variable)) +
      facet_wrap(~variable, scales = "free") +
      geom_line() +
      geom_point() +
      scale_y_log10() +
      labs(
        x = "Date",
        y = "Cases"
      )
    
  })
  
  output$plot.overview.r <- renderPlot({
    
    si_mean <- input$si_mean
    si_sd <- input$si_sd
    
    df.data() %>%
      summarise_ecdc %>%
      f_estimate_r(variable = "new_cases", si_mean = si_mean, si_sd = si_sd) %>%
      f_extract_r %>%
      ggplot(aes(x=t_end, y=`Mean(R)` )) +
      geom_point() +
      geom_line() +
      geom_ribbon(aes(ymin = `Quantile.0.025(R)`, ymax = `Quantile.0.975(R)`), alpha=0.1) +
      geom_hline(aes(yintercept = 1), colour = "red") +
      expand_limits(y=0) +
      labs(
        x = "Time (day)",
        y = "Estimated R"
      )
    
  })
  
  output$summary <- renderText({
    
    last_report <- df.data() %>%
      pull(date_reported) %>%
      max()
    
    glue::glue("<p>Last report from: <i>{last_report}</i></p>")
  })
  
  output$version <- renderText({
    
    glue::glue(
      "<div class='shiny-text-output'>
        <p>App Version: <i>{app_version}</i></p>
        <p>Shiny Version: <i>{shiny_version}</i></p>
      </div>", 
      app_version = APP_VERSION,
      shiny_version = packageVersion("shiny")
    )
    
  })
  
  #
  # Event Handlers
  #
  
  ## Event handler for the zoom
  # obs.click <- observeEvent(input$plot1_dblclick, {
  #   
  #   data <- data.od()
  #   
  #   if (nrow(data) > 0) {
  #     brush <- input$plot1_brush
  #     xlim.new <- c(min(data$time_h), max(data$time_h))
  #     if (!is.null(brush)) {
  #       xlim.new <- c(brush$xmin, brush$xmax)
  #     }
  #     updateSliderInput(session = session, "ranges", value=c(xlim.new[[1]], xlim.new[[2]] ))
  #   }
  #   
  # })
  
  #
  # Clean up
  #
  
  # When the client ends the session, suspend the observer.
  # Otherwise, the observer could keep running after the client
  # ends the session.
  session$onSessionEnded(function() {
    # obs.click$suspend()
  })
  
})

