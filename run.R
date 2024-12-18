library(tidyverse)
library(stringr)
library(rvest)
library(janitor)

source <- "https://bookwhen.com/"
studios <- c("dgcdance", "ventures-studio", "kpoplondonmin", "studio808", 
             "krewdancestudio", "dancetalkstudios", "bloomingdance")

# Functions ---------------------------------------------------------------

date <- Sys.Date()
studio <- studios[1]

fetch_dgc <- function(start_date) {
  
  
}

pg <- read_html(paste0("https://bookwhen.com/", studio, "?start=", as.character(date)))

event_codes <- na.omit(pg %>% html_elements("tr") %>% html_attr("data-event"))

l <- list()

for (i in 1:length(event_codes)) {
  
  pg <- read_html(paste0("https://bookwhen.com/", studio, "/e/", event_codes[i]))
  text <- pg %>% html_elements("div") %>% html_text()
  
  info <- text[grepl("Tickets", text)][1]
  info <- stringr::str_trim(gsub("\n|  ", "", info))
  
  #days <- paste(c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"), collapse = "|")
  df <- data.frame(title = stringr::str_trim(gsub(paste0(".*SchedulePassesEvent(.+)'.*"), "\\1", info)), 
                   date = stringr::str_trim(gsub(".*,(.+)GMT.*", "\\1", info)),
                   time = NA,
                   venue = stringr::str_trim(gsub(".*GMT (.+)Information.*", "\\1", info)),
                   instructor = NA,
                   #description = stringr::str_trim(gsub(".*Information(.+)Tickets.*", "\\1", info)),
                   cost = stringr::str_trim(gsub(".*Added£(.+)SelectSelect.*", "\\1", info)),
                   link = paste0("https://bookwhen.com/", studio, "/e/", event_codes[i])
                   )
  
  l[[i]] <- df
}

data <- bind_rows(l)
