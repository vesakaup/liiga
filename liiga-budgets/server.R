library(shiny)

liigabudget<-readRDS('./data/liiga.rds')
shinyServer(function(input, output) {
  
  selectedData <- reactive({
    
    liigabudget %>% filter (season %in% input$seasons )
    
  })
  
  
  output$plot1 <- renderPlot({
    
    ls<- selectedData() %>% na.omit() %>% group_by(team)%>%
      summarize(budget = round(sum(budget)/1000000,3), ppg=sum(points)/sum(games),
                seasons = round(games/60), avg_budget=sum(budget)/sum(seasons))
    
    
    ggplot(ls, aes(x=avg_budget,y=ppg)) +
      geom_point() +
      geom_text(aes(label=team)) +
      geom_smooth(method=lm, se=FALSE) +
      labs (x = "Average budget / season (MEUR)")
    
    
    
  })

  
  output$table <- renderTable({
    ls<- selectedData() %>% na.omit() %>% group_by(team)%>%
      summarize(games=sum(games), seasons= round(games/60), points=sum(points), ppg=points/games, avg_budget=round(sum(budget/seasons)/1000000,3), ppg=points/games)%>% arrange(desc(points))
               
    ls
  })
  
  
  
  
  
  
  
  
})