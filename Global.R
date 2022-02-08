Sys.setenv(LANG = "en")

requiredPackages = c("googlesheets4","ggplot2", "tidyverse","lubridate","DT","scales","shiny","plotly")

for(i in requiredPackages){if(!require(i,character.only = TRUE)) install.packages(i)}
for(i in requiredPackages){if(!require(i,character.only = TRUE)) library(i,character.only = TRUE)}



data_schedule <- read.csv(url("https://raw.githubusercontent.com/squareWFMsitel/AbsenteeismReports/main/Data/schedule.csv"))
data_activity <- read.csv(url("https://raw.githubusercontent.com/squareWFMsitel/AbsenteeismReports/main/Data/activity.csv"))
data_schedule2 <- read.csv(url("https://raw.githubusercontent.com/squareWFMsitel/AbsenteeismReports/main/Data/schedule2.csv"))

activity_roster <- read.csv(url("https://raw.githubusercontent.com/squareWFMsitel/AbsenteeismReports/main/Data/activityRoster.csv"))
agent_roster <- read.csv(url("https://raw.githubusercontent.com/squareWFMsitel/AbsenteeismReports/main/Data/agentRoster.csv"))
agent_roster$NICE.ID <- as.numeric(agent_roster$NICE.ID)





ProductiveActivities <- activity_roster$Activity[activity_roster$Paid_or_Not=="YES"]
AbsenceActivities <- activity_roster$Activity[activity_roster$Absence_NOT=="YES"]





#Scheduled Per Interval
data_schedule2$login <- as.POSIXct(paste(as.Date(data_schedule2$Date, origin = "1899-12-30"), data_schedule2$Start.time),  # Add hours, minutes & seconds
                                   format = "%Y-%m-%d %H:%M:%S")




data_schedule$Date <- as.Date(data_schedule$Date)
data_activity$Date <- as.Date(data_activity$Date)

data_activity$Length <- as.numeric(hms(paste0(data_activity$Length, ":00")))/3600
data_schedule$Length <- as.numeric(hms(paste0(data_schedule$Length, ":00")))/3600


data_schedule_Roster <- left_join(data_schedule, agent_roster, by = c("Agent.ID" = "NICE.ID"))
data_activity_Roster <- left_join(data_activity, agent_roster, by = c("Agent.ID" = "NICE.ID"))


Worked_perDay <- data_activity_Roster %>% filter(Agent.Activity %in% ProductiveActivities) %>% group_by(MU,Team.Lead, Locaton, Agent.ID,Agent.Name,Date) %>% summarise(Worked_Hrs = round(sum(Length,na.rm = TRUE),2))
Absence_perDay <- data_schedule_Roster %>% filter(Scheduled.Activity %in% AbsenceActivities) %>% group_by(Agent.ID,Agent.Name,Date) %>% summarise(Absent_Hrs = round(sum(Length,na.rm = TRUE),2))

Worked_Absence_perDay <- full_join(Worked_perDay, Absence_perDay, by = c("Agent.ID","Agent.Name","Date"))
Worked_Absence_perDay$Weeknum <- as.numeric(strftime(Worked_Absence_perDay$Date, format = "%V"))


