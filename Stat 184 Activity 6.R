library(tidyverse)
library(rvest)

rank_names_raw <- read_html(x = "https://neilhatfield.github.io/Stat184_PayGradeRanks.html") %>%
  html_elements(css = "table") %>%
  html_table()

us_armed_forces_raw <- read_html(x = "https://docs.google.com/spreadsheets/d/1cn4i0-ymB1ZytWXCwsJiq6fZ9PhGLUvbMBHlzqG4bwo/edit?pli=1&gid=597536282#gid=597536282") %>%
  html_elements(css = "table") %>%
  html_table()

rank_names_list <- rank_names_raw[[1]] 
 

us_armed_forces_list <- us_armed_forces_raw[[1]]

rank_names_list <- rank_names_list[1:25,]
us_armed_forces_list <- us_armed_forces_list[c(2,4:12,14:18,20:29),] #Removes Rows not Needed
us_armed_forces_list <- us_armed_forces_list[c(2,5,8,11,14,17)]  #Removes Columns not Needed
rank_names_list <- rank_names_list[-c(1,8)] #Removes Columns not Needed
us_armed_forces_list[us_armed_forces_list == ""] <- "Pay Grade" #Renames the Column "Pay Grade"

group_combined_df <- bind_cols(rank_names_list, us_armed_forces_list)

#Renaming all of the columns of the combined dataframes and remove 
names(group_combined_df)[2] <- "Army" 
names(group_combined_df)[3] <- "Navy"
names(group_combined_df)[4] <- "Marine_Corps"
names(group_combined_df)[5] <- "Air_Force"
names(group_combined_df)[6] <- "Space_Force"
group_combined_df <- group_combined_df[-c(1),] %>%
  mutate(
    Army = paste(Army, D, sep = " - "),
    Navy = paste(Navy, G, sep = " - "),
    "Marine Corps" = paste(Marine_Corps, J, sep = " - "),
    "Air Force" = paste(Air_Force, M, sep = " -  "),
    "Space Force" = paste(Space_Force, P, sep = " - ")
  )

#Drop duplicate columns
group_combined_df <- group_combined_df[-c(4:12)]

individual_cases <- us_armed_forces_list
#Renaming Columns and Deleting Duplicate Row
names(individual_cases)[1] <- "Pay_Grade"
names(individual_cases)[2] <- "Army"
names(individual_cases)[3] <- "Navy"
names(individual_cases)[4] <- "Marine_Corps"
names(individual_cases)[5] <- "Air_Force"
names(individual_cases)[6] <- "Space_Force"
individual_cases <- individual_cases[-c(1),]

individual_cases %>% pivot_longer(
  cols = c("Army", "Navy", "Marine_Corps", "Air_Force", "Space_Force"),
  names_to = "Military Branch",
  values_to = "Total"
) 
individual_cases_seprate <- uncount(individual_cases, 1254461)
