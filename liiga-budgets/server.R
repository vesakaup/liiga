library(shiny)

liigabudget<-readRDS('./data/liiga.rds')
shinyServer(function(input, output) {
    
    selectedData <- reactive({
   
        liigabudget %>% filter (season %in% input$seasons )
        
    })
    
    
    output$plot1 <- renderPlot({
        
       ls<- selectedData() %>% na.omit() %>% group_by(team)%>%
        summarize(budget = round(sum(budget)/1000000,3), ppg=sum(points)/sum(games),
                                    seasons = round(games/60), avg_budget=budget/seasons)

      
          ggplot(ls, aes(x=avg_budget,y=ppg)) +
          geom_point() +
          geom_text(aes(label=team)) +
          geom_smooth(method=lm, se=FALSE) +
          labs (x = "Average budget / season (MEUR)")
      


    })
    output$slope <- renderText({
        ls<- selectedData() %>% na.omit() %>% group_by(team)%>%
        summarize(budget = round(sum(budget)/1000000,3), ppg=sum(points)/sum(games),
                                    seasons = round(games/60), avg_budget=budget/seasons)
          lm(ppg~avg_budget, data=ls)[[1]][[2]]
          
      
    })
    output$intercept <- renderText({
      ls<- selectedData() %>% na.omit() %>% group_by(team)%>%
       summarize(budget = round(sum(budget)/1000000,3), ppg=sum(points)/sum(games),
                                    seasons = round(games/60), avg_budget=budget/seasons) 
      lm(ppg~avg_budget, data=ls)[[1]][[1]]
    })
    
    output$table <- renderTable({
      head(selectedData(),16)%>% na.omit() %>% select(-season) %>% group_by(team)%>% mutate (ppg = points/games) %>% arrange(desc(points)) 
    })
    
    

    
    
    
    
    
})