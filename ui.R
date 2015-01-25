library(shiny)

# Rely on the 'WorldPhones' dataset in the datasets
# package (which generally comes preloaded).
library(ggplot2) 
library(densityvis)
library(data.table)
library(stringr)

dt <- data.table(midwest)
setnames(dt, 'percollege', 'perccollege')
states <- unique(dt$state)
stats <- unlist(str_match_all(names(dt),'^perc.*'))
statnames <- str_replace(stats, '^perc(.*)', '\\1')
title <- "Exploring Midwest Demographic Distributions"

# Define the overall UI
shinyUI(
  
  # Use a fluid Bootstrap layout
  fluidPage(    
    
    # Give the page a title
    h1(title, align='center'),

    fluidRow(
      column(4, checkboxGroupInput("states", "States:", states, states)),
      column(4, selectInput("stat", "Statistic:", stats)),
      column(4, checkboxGroupInput("inmetro", "Area:",
                  c('Metro'= 'metro','Non-Metro' = 'nonmetro'),
                  c('metro','nonmetro')))
    ),
    fluidRow(
      column(4,helpText('Choose one or more midwest states')),
      column(4,helpText('Choose a demographic statistic to display')),
      column(4,helpText('Choose one or more metro areas'))
    ),
    fluidRow(
      column(6, plotOutput("dhist")),
      column(6, plotOutput("hist"))
    ),
    fluidRow(
      column(12, 
        p('Use this Shiny App to compare two ways of contructing histograms for various demographic measurements taken from the Midwest data set from the ggplot2 package.',align='left'),   
        p('You can subset the data set by choosing one or more states and one or more urbanicity (Metro & Non-Metro) indicators, then choosing a demographic statistic to visualize.',align='left'),   
        p('On the right a standard histogram employing equal-width bins is shown, and on the left is a diagonally cut histogram contructed with varying-width bins.',align='left'),  
        a('Data set documentation', href='http://docs.ggplot2.org/current/midwest.html', target="_blank")
      )
    )
  )
)