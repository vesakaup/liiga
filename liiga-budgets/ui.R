library(shiny)
library(ggplot2)
library(dplyr, warn.conflicts = FALSE)
options(dplyr.summarise.inform = FALSE)
liigabudget<-readRDS('./data/liiga.rds')
liigabudget <-liigabudget %>% filter(!(season=='2020-2021'))

shinyUI(fluidPage(
    titlePanel("Liiga teams' budgets and ppg in selected seasons"),
    sidebarLayout(
        sidebarPanel(
            widht = 6,
            selectInput('seasons', 'Select season(s)',liigabudget$season,
                        multiple=TRUE, selected ='2019-2020'),
            h1(""),
            h5("Dataset:"),      
            tableOutput('table')      
        ),
        mainPanel(
            h5("The charts shows teams budget and ppg in selected seasons."),
            h5("Source: liiga.fi & jatkoaika.com"),
            h5("A linear regression line is plotted."),
            plotOutput("plot1"),
            h4("Slope"),
            textOutput('slope'),
            h4('Intercept'),
            textOutput('intercept'),
         
            
        )
    )
))






