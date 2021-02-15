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
library(lubridate)
library(oddpub)
# citation('tidyverse')
# citation('medrxivr')


#### Get metadata ####
# Download copy of current database
med_data <- mx_snapshot()

# Raw stats as of 31 Jan, 2021
# 12,776 COVID articles total
# 9,931 in medRxiv
# 2,845 in bioRxiv

# Search database for COVID-19-related articles by keyword across title, abstract, and category. Sort results from oldest to newest.
# Output exclude duplicate title, abstract, and DOI
med_data <- med_data %>% filter(date >= "2019-12-01", date <= "2021-01-31")
med_results <- mx_search(data = med_data, query = c("COVID-19",
                                                    "COVID 19",
                                                    "covid-19",
                                                    "covid 19",
                                                    "SARS-CoV-2",
                                                    "SARSCoV-2",
                                                    "corona virus",
                                                    "Corona Virus",
                                                    "coronavirus", 
                                                    "2019-nCoV",
                                                    "coronavirus-2"), auto_caps = TRUE) # n = 9,9,929
med_results <- med_results[order(med_results$date),]

# Save results - this is sampling frame (info for all medRxiv COVID-19 papers)
write_csv(med_results, "outputs/data/med_results.csv")

# Sometimes a paper has multiple versions - EXCLUDED IN PREVIOUS STEP, THIS IS MOOT
# Filter to only uniques and keep latest version of the paper
# med_results_unique <- med_results[!duplicated(med_results[c(2)]),]

# Summarise and graph by date
med_daily_sum <- med_results %>% group_by(date) %>% summarise(date = date, total = n())
med_plot <- med_daily_sum %>% ggplot() + geom_line(aes(x=date, y=total)) + geom_smooth(aes(x=date, y=total))
med_plot

# Sample from results
set.seed(100)
med_sample <- med_results[sample(nrow(med_results), 1200),]
med_sum <- med_sample %>% group_by(month=floor_date(date, "month")) %>% summarise(num=n())
write_csv(med_sample, "outputs/data/med_sample.csv")

  
#### Download relevant papers ####
# Set up folders for download and txt conversion
med_pdf_folder = paste(getwd(), "/outputs/data/pdf-medRxiv", sep = "")
med_txt_folder = paste(getwd(), "/outputs/data/text-medRxiv", sep = "")

# Download first 500 papers and latest 500 and save to computer
# head(med_results, 500) %>% mx_download(directory = med_pdf_folder, create = FALSE)
# tail(med_results, 500) %>% mx_download(directory = med_pdf_folder, create = FALSE)

# Download randomly sampled PDFs (will not)
med_sample %>% mx_download(directory = med_pdf_folder, create = FALSE)

# Convert PDFs to text and saves in new folder
pdf_convert(med_pdf_folder, med_txt_folder)


#### Clean up ####
rm()
