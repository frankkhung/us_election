#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from https://usa.ipums.org/usa-action/variables/group
# Author: Chien-Che Hung
# Data: 02 November 2020
# Contact: chienche.hung@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the ACS (https://usa.ipums.org/usa-action/variables/group) data and saved it to inputs/data
# - Follow the README file in the Github Repository: https://github.com/frankkhung/us_election
# - Any forms of this dataset should not be uploaded to any platform!


#### Workspace setup ####
library(haven)
library(tidyverse)
# Read in the raw data. 
raw_data <- read_dta("inputs/data/usa_00004.dta")
# Add the labels since it was in dta format
raw_data <- labelled::to_factor(raw_data)

# selec the variables that we are interested in
reduced_post <- 
  raw_data %>% 
  select(stateicp,
         sex, 
         age, 
         race, 
         bpl,
         educd,
         empstat,
         inctot) %>% mutate_all(as.character)

         

#### Edit each variable to match the individual level data ####

# sex/gender (it is in uppercase in Nationscape Data)
reduced_post$sex[raw_data$sex == "male"] <- "Male"
reduced_post$sex[raw_data$sex == "female"] <- "Female"

# change the state names to abbreviation 
reduced_post$stateicp <- tolower(reduced_post$stateicp)
state <- tolower(state.name) 
# in the state function, there is no district of columbia since they 
# technicially is not a state. We will have to add time manually
state <- append(state, "district of columbia")
state.abb <- append(state.abb, "DC")
reduced_post$stateicp <- state.abb[match(reduced_post$stateicp , state)]

# birthplace
# Whether born in the united states or not
to <- replicate(length(states), "The United States")
map  = setNames(to, states)
reduced_post$bpl <- map[reduced_post$bpl]
reduced_post$bpl <- reduced_post$bpl %>% replace_na("Another country") 

# change age into ranges
# same as Nationscape data, it was originally in numbers. It would be easier to analyze to make in in categories
reduced_post$age <- as.integer(reduced_post$age)
# remove age lower than 18 (voting age) since it is a census data and people who are under 18 are not available to vote.
# Thus, we are removing unreliable observations
reduced_post <- reduced_post[!is.na(reduced_post$age),]
reduced_post <- reduced_post[!(reduced_post$age < 18),]
labs <- c(paste(seq(0, 95, by = 10), seq(0 + 10 - 1, 100 - 1, by = 10),
                sep = "-"), paste(100, "+", sep = ""))
reduced_post$age <- cut(reduced_post$age, breaks = c(seq(0, 100, by = 10), Inf), labels = labs, right = FALSE)
reduced_post$age <- as.character(reduced_post$age)


# change education since the education in this data is relatively more detailed the the Nationscape 
reduced_post$educd[reduced_post$educd == "1 or more years of college credit, no degree"] <- "Completed some college, but no degree"
reduced_post$educd[reduced_post$educd == "12th grade, no diploma"] <- "Completed some high school"
reduced_post$educd[reduced_post$educd == "associate's degree, type not specified"] <- "Associate Degree"
reduced_post$educd[reduced_post$educd == "bachelor's degree"] <- "College Degree (such as B.A., B.S.)"
reduced_post$educd[reduced_post$educd == "doctoral degree"] <- "Doctorate degree"
reduced_post$educd[reduced_post$educd == "ged or alternative credential"] <- "Other post high school vocational training"
reduced_post$educd[reduced_post$educd == "grade 1"] <- "3rd Grade or less"
reduced_post$educd[reduced_post$educd == "grade 2"] <- "3rd Grade or less"
reduced_post$educd[reduced_post$educd == "grade 3"] <- "3rd Grade or less"
reduced_post$educd[reduced_post$educd == "kindergarten"] <- "3rd Grade or less"
reduced_post$educd[reduced_post$educd == "no schooling completed"] <- "3rd Grade or less"
reduced_post$educd[reduced_post$educd == "nursery school, preschool"] <- "3rd Grade or less"
reduced_post$educd[reduced_post$educd == "grade 4"] <- "Middle School - Grades 4 - 8"
reduced_post$educd[reduced_post$educd == "grade 5"] <- "Middle School - Grades 4 - 8"
reduced_post$educd[reduced_post$educd == "grade 6"] <- "Middle School - Grades 4 - 8"
reduced_post$educd[reduced_post$educd == "grade 7"] <- "Middle School - Grades 4 - 8"
reduced_post$educd[reduced_post$educd == "grade 8"] <- "Middle School - Grades 4 - 8"
reduced_post$educd[reduced_post$educd == "grade 9"] <- "Completed some high school"
reduced_post$educd[reduced_post$educd == "grade 10"] <- "Completed some high school"
reduced_post$educd[reduced_post$educd == "grade 11"] <- "Completed some high school"
reduced_post$educd[reduced_post$educd == "master's degree"] <- "Masters degree"
reduced_post$educd[reduced_post$educd == "professional degree beyond a bachelor's degree"] <- "Other post high school vocational training"
reduced_post$educd[reduced_post$educd == "regular high school diploma"] <- "High school graduate"
reduced_post$educd[reduced_post$educd == "some college, but less than 1 year"] <- "Completed some college, but no degree"

# set cateories for income levels. The income were in numbers and the income variable in the Nationscape data is in categories
# thus we have to change this part
reduced_post <- reduced_post[!is.na(reduced_post$inctot),]
reduced_post$inctot<- as.integer(reduced_post$inctot)
ranges <- c(-1, 14999, 19999, 24999, 29999, 34999, 39999, 44999, 49999, 54999, 59999, 64999, 69999, 74999, 79999,
            84999, 89999, 94999, 99999, 124999, 149999, 174999, 199999, 249999, 999999)
reduced_post$inctot <- cut(reduced_post$inctot, ranges)
level <- c("Less than $14,999", "$15,000 to $19,999", "$20,000 to $24,999", "$25,000 to $29,999", "$30,000 to $34,999",
           "$35,000 to $39,999", "$40,000 to $44,999", "$45,000 to $49,999", "$50,000 to $54,999", "$55,000 to $59,999",
           "$60,000 to $64,999", "$65,000 to $69,999", "$70,000 to $74,999", "$75,000 to $79,999", "$80,000 to $84,999",
           "$85,000 to $89,999", "$90,000 to $94,999", "$95,000 to $99,999", "$100,000 to $124,999", "$125,000 to $149,999"
           , "$150,000 to $174,999", "$175,000 to $199,999", "$200,000 to $249,999", "$250,000 and above")
levels(reduced_post$inctot) <- level
reduced_post$inctot <- as.character(reduced_post$inctot)
reduced_post <- reduced_post[!is.na(reduced_post$inctot),]


# clean up race and ethnicity. since three or more major races and two major races are ambiguous and have to function
reduced_post$race[reduced_post$race == "three or more major races"] <- NA
reduced_post$race[reduced_post$race == "two major races"] <- NA
reduced_post <- reduced_post[!is.na(reduced_post$race),]

# change column names in order to match with the Nationscape data
col <- c("state", "gender", "age", "race_ethnicity", "foreign_born", "education", "employment", "household_income")
colnames(reduced_post) <- col

# Save the dataset into a csv and used in other analysis
write_csv(reduced_post, "inputs/data/post_level.csv")
# remove data that wont be used
rm(reduced_post)
rm(raw_data)
