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
# TODO: We probably want to change this to purrr::map_dfr() or something else more mainstream.


#### Identify open data markers ####
med_open_data_results <- 
  oddpub::open_data_search(med_text_sentences)
# TODO: Again, probably want to change this to stringr::str_detect(). The documentation 
# for this is weird. 'The algorithm searches...'. 
# Also this takes ages. We want to re-write it so that it runs loudly.

# Save it 
# 'outputs/data/med_open_data_results.csv?'
# TODO


#### Summary statistics ####
# Read in data
# TODO

# Counts
med_open_data_results %>% 
  count(is_open_data, is_open_code)



