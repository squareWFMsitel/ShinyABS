
library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
  data_ABSperTL_daily <- reactive({# data
    Worked_Absence_perDay %>% filter(Team.Lead %in% input$TL & Date>=input$daterange[1] & Date<=input$daterange[2]) %>% 
      group_by(Team.Lead,Weeknum)%>%summarise(PercentABS = 100*sum(Absent_Hrs,na.rm = TRUE)/(sum(Absent_Hrs,na.rm = TRUE) + sum(Worked_Hrs,na.rm = TRUE)))
    
    
  })
  
  data_ABSperTL_daily2 <- reactive({# data
    Worked_Absence_perDay %>% filter(MU %in% input$mu2 & Date>=input$daterange2[1] & Date<=input$daterange2[2]) %>% 
      group_by(MU,Weeknum)%>%summarise(PercentABS = 100*sum(Absent_Hrs,na.rm = TRUE)/(sum(Absent_Hrs,na.rm = TRUE) + sum(Worked_Hrs,na.rm = TRUE)))
    
    
  })
  
  
  output$hot <- DT::renderDataTable({
    data_ABSperTL_daily()
  })
  
  
  
  
  output$ABSperMU_weekly <- renderPlotly({
    
    ggplot(data = data_ABSperTL_daily()[complete.cases(data_ABSperTL_daily()),],
           aes(x = Weeknum, y = PercentABS, color = Team.Lead)) +
      geom_point(size = 2)+
      geom_line(size = 1)+
      labs(title = "ABSENTEEISM per TL PER WEEK",
           x ="Week", y = "ABS%")+
      theme(axis.text.x = element_text(angle = 60, vjust = 0.5, hjust=1)) +
      scale_x_continuous(labels = unique(data_ABSperTL_daily()$Weeknum), breaks = unique(data_ABSperTL_daily()$Weeknum))+
      xlim(1,as.numeric(strftime(Sys.Date(), format = "%V")))
    
    
  })
  
  output$ABSperTL_weekly2 <- renderPlotly({
    
    ggplot(data = data_ABSperTL_daily2()[complete.cases(data_ABSperTL_daily2()),],
           aes(x = Weeknum, y = PercentABS, color = MU)) + 
      geom_point(size = 2)+
      geom_line(size = 1)+
      labs(title = "ABSENTEEISM per MU PER WEEK",
           x ="Week", y = "ABS%")+
      theme(axis.text.x = element_text(angle = 60, vjust = 0.5, hjust=1)) +
      scale_x_continuous(labels = unique(data_ABSperTL_daily2()$Weeknum), breaks = unique(data_ABSperTL_daily2()$Weeknum))+
      xlim(1,as.numeric(strftime(Sys.Date(), format = "%V")))
    
    
  })
  
  
})



