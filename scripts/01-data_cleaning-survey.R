#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from [...UPDATE ME!!!!!]
# Author: Rohan Alexander and Sam Caetano [CHANGE THIS TO YOUR NAME!!!!]
# Data: 22 October 2020
# Contact: chienche.hung@mail.utoronto.ca[PROBABLY CHANGE THIS ALSO!!!!]
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the data from X and save the folder that you're 
# interested in to inputs/data 
# - Don't forget to gitignore it!


#### Workspace setup ####
library(haven)
library(tidyverse)
library(dplyr)
# Read in the raw data (You might need to change this if you use a different dataset)
raw_data <- read_dta("inputs/data/ns20200625.dta")
# Add the labels
raw_data <- labelled::to_factor(raw_data)
# Just keep some variables
reduced_data <- 
  raw_data %>% 
  select(interest,
         registration,
         vote_intention,
         vote_2016,
         vote_2020,
         vote_2020_lean,
         ideo5,
         employment,
         foreign_born,
         gender,
         race_ethnicity,
         household_income,
         education,
         state,
         age) %>%
  as_tibble() %>%
  mutate_all(as.character)


#### What else???? ####
# Maybe make some age-groups?
# Maybe check the values?
# Is vote a binary? If not, what are you going to do?


reduced_data <- reduced_data %>% 
  mutate(vote = ifelse(vote_2016 == "Donald Trump" | vote_2016 == "Hillary Clinton" 
                       | vote_2016 == "Gary Johnson" | vote_2016 == "Jill Stein" |
                         vote_2016 == "Someone else:", "Voted", "Did Not Vote"))

reduced_data$race_ethnicity[reduced_data$race_ethnicity == "American Indian or Alaska Native"] <- "american indian or alaska native"
reduced_data$race_ethnicity[reduced_data$race_ethnicity == "Asian (Asian Indian)"] <- "other asian or pacific islander"
reduced_data$race_ethnicity[reduced_data$race_ethnicity == "Asian (Korean)"] <- "other asian or pacific islander"
reduced_data$race_ethnicity[reduced_data$race_ethnicity == "Asian (Chinese)"] <- "chinese"
reduced_data$race_ethnicity[reduced_data$race_ethnicity == "Asian (Filipino)"] <- "other asian or pacific islander"
reduced_data$race_ethnicity[reduced_data$race_ethnicity == "Asian (Japanese)"] <- "japanese"
reduced_data$race_ethnicity[reduced_data$race_ethnicity == "Asian (Other)"] <- "other asian or pacific islander"
reduced_data$race_ethnicity[reduced_data$race_ethnicity == "Asian (Vietnamese)"] <- "other asian or pacific islander"
reduced_data$race_ethnicity[reduced_data$race_ethnicity == "Black, or African American"] <- "black/african american/negro"
reduced_data$race_ethnicity[reduced_data$race_ethnicity == "Pacific Islander (Guamanian)"] <- "other asian or pacific islander"
reduced_data$race_ethnicity[reduced_data$race_ethnicity == "Pacific Islander (Native Hawaiian)"] <- "other asian or pacific islander"
reduced_data$race_ethnicity[reduced_data$race_ethnicity == "Pacific Islander (Other)"] <- "other asian or pacific islander"
reduced_data$race_ethnicity[reduced_data$race_ethnicity == "Pacific Islander (Samoan)"] <- "other asian or pacific islander"
reduced_data$race_ethnicity[reduced_data$race_ethnicity == "Some other race"] <- "other race, nec"
reduced_data$race_ethnicity[reduced_data$race_ethnicity == "White"] <- "white"


# change age into ranges
reduced_data$age <- as.integer(reduced_data$age)
labs <- c(paste(seq(0, 95, by = 10), seq(0 + 10 - 1, 100 - 1, by = 10),
                sep = "-"), paste(100, "+", sep = ""))
reduced_data$age <- cut(reduced_data$age, breaks = c(seq(0, 100, by = 10), Inf), labels = labs, right = FALSE)
reduced_data$age <- as.character(reduced_data$age)

# drop na columns for income 
reduced_data <- reduced_data[!is.na(reduced_data$household_income),]

## change the employment categories 
# remove na
reduced_data <- reduced_data[!is.na(reduced_data$employment),]
reduced_data$employment[reduced_data$employment == "Full-time employed"] <- "employed"
reduced_data$employment[reduced_data$employment == "Part-time employed"] <- "employed"
reduced_data$employment[reduced_data$employment == "Self-employed"] <- "employed"
reduced_data$employment[reduced_data$employment == "Homemaker"] <- "not in labor force"
reduced_data$employment[reduced_data$employment == "Permanently disabled"] <- "not in labor force"
reduced_data$employment[reduced_data$employment == "Retired"] <- "not in labor force"
reduced_data$employment[reduced_data$employment == "Student"] <- "not in labor force"
reduced_data$employment[reduced_data$employment == "Other:"] <- "not in labor force"
reduced_data$employment[reduced_data$employment == "Unemployed or temporarily on layoff"] <- "unemployed"


# combine vote_2020 and vote_2020_lean
reduced_data$vote_2020[reduced_data$vote_2020 == "Someone else"] <- NA
reduced_data <- reduced_data[!is.na(reduced_data$vote_2020),]
reduced_data <- reduced_data[!is.na(reduced_data$vote_2020_lean),]

reduced_data$vote_2020[reduced_data$vote_2020 == "I am not sure/don't know"] <- NA
reduced_data$vote_2020[reduced_data$vote_2020 == "I would not vote"] <- NA

reduced_data$vote_2020 <- ifelse(is.na(reduced_data$vote_2020), reduced_data$vote_2020_lean, reduced_data$vote_2020)




write_csv(reduced_data, "inputs/data/ind_level.csv")
rm(reduced_data)


