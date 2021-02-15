#### Preamble ####
# Purpose: Download the txt files of the PDFs downloaded from biorxiv in 01-data_gathering_mexrxiv.R
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
# bio_txt_folder = paste(getwd(), ", sep = "")
# Load text files into list of string vectors for use in text mining algorithm.
# Returns list of lists, with one list for each document (paper)
bio_text_sentences <- 
  oddpub::pdf_load(here::here("outputs/data/text-bioRxiv/")) # Requires closing backslash


# TODO: Maybe want to change this to something else more mainstream.
# Example starts here
# install.packages("readtext")
# bio_text <- 
# readtext::readtext(file = here::here("outputs/data/text-bioRxiv/*.txt"))
# This function can actually directly take PDFs so may want to consider that also eventually.
# Example ends here


#### Identify open data markers ####
bio_open_data_results <- 
  oddpub::open_data_search(bio_text_sentences)

# INTERIM SAVE
class(bio_open_data_results)
write_csv(bio_open_data_results, 'outputs/data/bio_open_data_results.csv')

# TODO: Maybe want to see if we can re-write this to run faster?
# Example starts here

# Example ends here


# Save it 
class(bio_open_data_results)
write_csv(bio_open_data_results, 'outputs/data/bio_open_data_results.csv')


#### Summary statistics ####
# Read in data
# TODO

# Counts
bio_open_data_results %>% 
  count(is_open_data, is_open_code)



