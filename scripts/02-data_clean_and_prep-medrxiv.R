#### Preamble ####
# Purpose: Download the txt files of the PDFs downloaded from medrxiv in 01-data_gathering_mexrxiv.R
# Author: Annie Collins and Rohan Alexander
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
# med_txt_folder = paste(getwd(), ", sep = "")
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


# Save it 
class(med_open_data_results)
write_csv(med_open_data_results, 'outputs/data/med_open_data_results.csv')


#### Summary statistics ####
# Read in data
# TODO

# Counts
med_open_data_results %>% 
  count(is_open_data, is_open_code)



