# Data Cleaning and Prep - SocArXiv

# rbind open data results from docx and pdf files together
# join all open data results to covid_socarxiv_metadata by `id`

#### Preamble ####
# Purpose: Download the txt files of the PDFs downloaded from socarxiv in 01-data_gathering_socarxiv.R
# Author: Annie Collins, Rohan Alexander
# Data: 12 February 2021
# Contact: rohan.alexander@utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded PDFs and converted them to txt files saved in outputs/data/


#### Workspace setup ####
# Use R Projects, not setwd().
library(oddpub)
library(tidyverse)

# Load text files into list of string vectors for use in text mining algorithm.
# Returns list of lists, with one list for each document (paper)
socarxiv_text_sentences <- 
  oddpub::pdf_load(here::here("outputs/data/text-socarxiv/")) # Requires closing backslash

#### Identify open data markers ####
socarxiv_open_data_results <- 
  oddpub::open_data_search(socarxiv_text_sentences)


# DONE up to here, rest TODO

# Join covid_socarxiv_metadata to socarxiv_open_data_results and save as socarxiv_open_data_results
socarxiv_open_data_results <- socarxiv_open_data_results %>% mutate(id = str_sub(socarxiv_open_data_results$article, 1, 5)) %>% select(!article)
socarxiv_open_data_results <- left_join(covid_socarxiv_metadata, socarxiv_open_data_results, by = c("id"))

# Convert TRUE/FALSE in ODDPub output to 1/0
socarxiv_open_data_results$is_open_code <- as.integer(socarxiv_open_data_results$is_open_code)
socarxiv_open_data_results$is_open_data <- as.integer(socarxiv_open_data_results$is_open_data)

# TODO: Add variable for type of paper - "machine learning", "model"/"modeling", "simulation", "simulate"?

# Add variable 

# Save it 
class(socarxiv_open_data_results)
write_csv(socarxiv_open_data_results, 'outputs/data/socarxiv_open_data_results.csv')


#### Summary statistics ####
# Read in data
socarxiv_open_data_results <- read.csv('outputs/data/socarxiv_open_data_results.csv')

# Counts
socarxiv_open_data_results %>% 
  count(is_open_data, is_open_code)
