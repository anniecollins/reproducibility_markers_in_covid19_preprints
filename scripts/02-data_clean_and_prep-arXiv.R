#### Preamble ####
# Purpose: Parse the txt files created from the PDFs downloaded from arxiv in 01-data_gathering_arxiv.R
# Author: Rohan Alexander
# Data: 5 March 2021
# Contact: rohan.alexander@utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded PDFs and converted them to txt files saved in outputs/data/


#### Workspace setup ####
# library(medrxivr)
library(oddpub)
library(tidyverse)

# Read in the raw data. 
# med_txt_folder = paste(getwd(), ", sep = "")
# Load text files into list of string vectors for use in text mining algorithm.
# Returns list of lists, with one list for each document (paper)
arxiv_text_sentences <- 
  oddpub::pdf_load(here::here("outputs/data/text-arXiv/")) # Requires closing backslash
arxiv_sample <- 
  read_csv("outputs/data/arxiv_sample.csv")


#### Identify open data markers ####
arxiv_open_data_results <- 
  oddpub::open_data_search(arxiv_text_sentences)

# Join the dataset with the metadata with the dataset with the open markers
arxiv_open_data_results <- 
  arxiv_open_data_results %>% 
  mutate(id = str_remove(article, "\\.txt"))

arxiv_open_data_results <- left_join(arxiv_sample, arxiv_open_data_results, by = "id")

# Convert TRUE/FALSE in ODDPub output to 1/0
arxiv_open_data_results$is_open_code <- as.integer(arxiv_open_data_results$is_open_code)
arxiv_open_data_results$is_open_data <- as.integer(arxiv_open_data_results$is_open_data)

# Save it 
write_csv(arxiv_open_data_results, 'outputs/data/arxiv_open_data_results.csv')


# Counts
arxiv_open_data_results %>% 
  count(is_open_data, is_open_code)

