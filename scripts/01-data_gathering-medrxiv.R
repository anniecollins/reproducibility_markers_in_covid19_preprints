#### Preamble ####
# Purpose: Download papers from medrxiv that are related to COVID-19.
# Author: Annie Collins and Rohan Alexander
# Data: 12 February 2021
# Contact: rohan.alexander@utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need the following packages:
#   - devtools::install_github("mcguinlu/medrxivr")


#### Workspace setup ####
library(medrxivr)
library(tidyverse)
# citation('tidyverse')
# citation('medrxivr')


#### Get metadata ####
# Download copy of current database
med_data <- mx_api_content(from_date = "2019-12-01", to_date = "2021-01-31", server = "medrxiv") # n = 20,108 (31 Jan, 2021)

# Raw stats as of 31 Jan, 2021
# 12,776 COVID articles total
# 9,931 in medRxiv
# 2,845 in bioRxiv

# Search database for COVID-19-related articles by keyword across title, abstract, and category. Sort results from oldest to newest.
med_results <- mx_search(data = med_data, query = c("covid-19", "sars-cov-2", "coronavirus")) # n = 2,584 (31 Jan, 2021)
med_results <- med_results[order(med_results$date),]

# Sometimes a paper has multiple versions
# Filter to only uniques and keep latest version of the paper
# TODO

# Summarise and graph by date
med_daily_sum <- med_results %>% group_by(date) %>% summarise(date = date, total = n())
med_plot <- med_daily_sum %>% ggplot() + geom_line(aes(x=date, y=total)) + geom_smooth(aes(x=date, y=total))


#### Download relevant papers ####
# Set up folders for download and txt conversion
med_pdf_folder = paste(getwd(), "inputs/data/pdfs-medRxiv", sep = "")
med_txt_folder = paste(getwd(), "outputs/data/text-medRxiv", sep = "")

# Download first 500 papers and latest 500 and save to computer
head(med_results, 500) %>% mx_download(directory = med_pdf_folder, create = FALSE)
tail(med_results, 500) %>% mx_download(directory = med_pdf_folder, create = FALSE)

# Convert PDFs to text and saves in new folder
pdf_convert(med_pdf_folder, med_txt_folder)


#### Clean up ####
rm()
