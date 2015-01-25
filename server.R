library(shiny)
library(ggplot2) 
library(data.table)
library(stringr)
library(histogram)
library(densityvis)
source('dhist.R')

dt <- data.table(midwest)
setnames(dt, 'percollege', 'perccollege')

# Define a server for the Shiny app
shinyServer(function(input, output) {
  
  # Fill in the spot we created for a plot
  output$dhist <- renderPlot({
    
    sel_states <- input$states
    sel_stat   <- input$stat
    sel_metro  <- input$inmetro
    
    metro_filter <- numeric(0)
    if ('metro'    %in% sel_metro) metro_filter <- c(metro_filter, 1)
    if ('nonmetro' %in% sel_metro) metro_filter <- c(metro_filter, 0)
    
    demo <- data.table(dt[ state %in% sel_states & inmetro %in% metro_filter, ][[sel_stat]])/100
    
    setnames(demo,'V1','pct')

    dbreaks <- dhist(demo$pct,plot=FALSE)$xbr
    
    g0 <- ggplot(demo, aes(x=pct)) 
    g1 <- g0 + geom_histogram(breaks=dbreaks, fill="white", colour="black",position='identity')
    g2 <- g1 + labs(title=paste0('Diagonally Cut Histogram ',sel_stat)
                    ,y='Number of counties', x='Percentage of demographic')
    g2
  })

  output$hist <- renderPlot({
    
    sel_states <- input$states
    sel_stat   <- input$stat
    sel_metro  <- input$inmetro
    
    metro_filter <- numeric(0)
    if ('metro'    %in% sel_metro) metro_filter <- c(metro_filter, 1)
    if ('nonmetro' %in% sel_metro) metro_filter <- c(metro_filter, 0)
    
    demo <- data.table(dt[ state %in% sel_states & inmetro %in% metro_filter, ][[sel_stat]])/100
    
    setnames(demo,'V1','pct')
    
    hbreaks <- histogram(demo$pct,plot=FALSE,verbose=FALSE)$breaks
    
    g0 <- ggplot(demo, aes(x=pct)) 
    g1 <- g0 + geom_histogram(breaks=hbreaks, fill="white", colour="black",position='identity')
    g2 <- g1 + labs(title=paste0('Regular Histogram ',sel_stat)
                    ,y='Number of counties', x='Percentage of demographic')
    g2
  })
})