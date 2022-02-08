fluidPage(
  sidebarLayout(position = "left",
                
                sidebarPanel(
                  selectInput("TL", "Team Leader:",
                              choices = unique(Worked_Absence_perDay$Team.Lead),selected = unique(Worked_Absence_perDay$Team.Lead),multiple = TRUE),
                  
                  dateRangeInput("daterange", "Date range:",
                                 start = min(Worked_Absence_perDay$Date),
                                 end = max(Worked_Absence_perDay$Date)),
                ),
                mainPanel("Plots",
                          
                          plotlyOutput("ABSperMU_weekly"),
                          br(),
                          
                          DT::dataTableOutput("hot")
                          
                )
  ),
  br(),
  br(),
  br(),
  
  sidebarLayout(position = "left",
                
                sidebarPanel(selectInput("mu2", "MU:",
                                         choices = unique(Worked_Absence_perDay$MU), selected = unique(Worked_Absence_perDay$MU),multiple = TRUE),
                             
                             dateRangeInput("daterange2", "Date range:",
                                            start = min(Worked_Absence_perDay$Date),
                                            end = max(Worked_Absence_perDay$Date)),
                ),
                mainPanel(
                  plotlyOutput("ABSperTL_weekly2")
                  
                )
  )
  
)