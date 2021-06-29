#### Preamble ####
# Purpose: Download the txt files of the PDFs downloaded from medrxiv in 01-data_gathering_mexrxiv.R
# Author: Annie Collins
# Data: 12 February 2021
# Contact: rohan.alexander@utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded PDFs and converted them to txt files saved in outputs/data/


#### Workspace setup ####
# Use R Projects, not setwd().
library(medrxivr)
library(oddpub)
library(tidyverse)

# Read in the raw data. 
# med_txt_folder <- paste(getwd(), ", sep = "")

# Load text files into list of string vectors for use in text mining algorithm.
# Returns list of lists, with one list for each document (paper)
med_text_sentences <- 
  oddpub::pdf_load(here::here("outputs/data/text-medRxiv/")) # Requires closing backslash

# TODO: Maybe want to change this to something else more mainstream.
# Example starts here
# install.packages("readtext")
# med_text <- 
  # readtext::readtext(file = here::here("outputs/data/text-medRxiv/*.txt"))
# This function can actually directly take PDFs so may want to consider that also eventually.
# Example ends here


#### Identify open data markers ####
med_open_data_results <- 
  oddpub::open_data_search(med_text_sentences)


# TODO: Maybe want to see if we can re-write this to run faster?
# Example starts here

# Example ends here

# Join med_sample to med_open_data_results and save as med_open_data_results
med_open_data_results$join_id <- str_sub(med_open_data_results$article, -23, -5)
med_sample$join_id <- str_sub(med_sample$doi, start = -19)
med_open_data_results <- merge(med_sample, med_open_data_results, by = "join_id")

# Reassign published values to 0 or 1 based on presence of publication
med_open_data_results$published[!is.na(med_open_data_results$published)] <- 1
med_open_data_results$published[is.na(med_open_data_results$published)] <- 0

# Convert TRUE/FALSE in ODDPub output to 1/0
med_open_data_results$is_open_code <- as.integer(med_open_data_results$is_open_code)
med_open_data_results$is_open_data <- as.integer(med_open_data_results$is_open_data)

# TODO: Add variable for type of paper - "machine learning", "model"/"modeling", "simulation", "simulate"?

# Add variable 

# Save it 
class(med_open_data_results)
write_csv(med_open_data_results, 'outputs/data/med_open_data_results.csv')





#### Pre-pandemic data ####
# See comments above for suggests. Need to keep processing in this step same as sampled COVID-19 pre-prints above.
med_2019_text_sentences <- 
  oddpub::pdf_load(here::here("outputs/control-data/text-medRxiv/")) # Requires closing backslash

#### Identify open data markers ####
med_2019_open_data_results <- 
  oddpub::open_data_search(med_2019_text_sentences)

med_2019_open_data_results <- med_2019_open_data_results %>% select(article, is_open_data, open_data_category, is_open_code, open_data_statements, open_code_statements)

# Join med_data_2019 to med_2019_open_data_results and save as med_2019_open_data_results
# TODO: Double check join_id
med_2019_open_data_results$join_id <- med_2019_open_data_results$article %>% str_remove(".txt") %>% str_replace_all("_", "/") %>% substr(start=2, stop=50)
# med_data_2019$join_id <- str_sub(med_data_2019$doi, start = -19)
med_2019_open_data_results <- left_join(med_data_2019, med_2019_open_data_results, by = c("doi" = "join_id"))

# Reassign published values to 0 or 1 based on presence of publication
med_2019_open_data_results$published[!med_2019_open_data_results$published == "NA"] <- 1
med_2019_open_data_results$published[med_2019_open_data_results$published == "NA"] <- 0

# Convert TRUE/FALSE in ODDPub output to 1/0
med_2019_open_data_results$is_open_code <- as.integer(med_2019_open_data_results$is_open_code)
med_2019_open_data_results$is_open_data <- as.integer(med_2019_open_data_results$is_open_data)

# Save it 
class(med_2019_open_data_results)
write_csv(med_2019_open_data_results, 'outputs/control-data/med_2019_open_data_results.csv')


#### Summary statistics ####
# Read in data
# TODO

# Counts
med_open_data_results %>% 
  count(is_open_data, is_open_code)



