#### Preamble ####
# Purpose: Download papers from medrxiv that are related to COVID-19.
# Author: Annie Collins
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

# Keep snapshot of pre-pandemic database (see 'Pre-Pandemic Data' below)
med_data_2019 <- med_data %>% filter(date <= "2019-12-31")

# Raw stats as of 22 May, 2021 (from medRxiv website)
# 16,135 COVID articles total
# 12,450 in medRxiv
# 3,685 in bioRxiv

# Search database for COVID-19-related articles by keyword across title, abstract, and category. Sort results from oldest to newest.
# Output exclude duplicate title, abstract, and DOI
med_data <- med_data %>% filter(date >= "2019-12-01", date <= "2021-05-01")
med_results <- mx_search(data = med_data, query = c("COVID-19",
                                                    "COVID 19",
                                                    "covid-19",
                                                    "covid 19",
                                                    "novel coronavirus",
                                                    "novel corona virus",
                                                    "SARS-CoV-2",
                                                    "SARSCoV-2",
                                                    "sars-cov-2",
                                                    "sars-CoV-2",
                                                    "corona virus",
                                                    "Corona Virus",
                                                    "coronavirus", 
                                                    "2019-nCoV",
                                                    "coronavirus-2"), auto_caps = TRUE) # n = 12,060
med_results <- med_results[order(med_results$date),]

# Save results - this is sampling frame (info for all medRxiv COVID-19 papers)
write_csv(med_results, "outputs/data/med_results.csv")

# Summarise and graph by date
med_daily_sum <- med_results %>% group_by(date) %>% summarise(date = date, total = n())
med_plot <- med_daily_sum %>% ggplot() + geom_line(aes(x=date, y=total)) + geom_smooth(aes(x=date, y=total))
med_plot

# Sample from results
set.seed(100)
med_sample <- med_results[sample(nrow(med_results), 1500),]
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
# Stopped at row 1067 (broken URL?); added slice to skip entry after pause
med_sample %>% slice(1068:1500) %>% mx_download(directory = med_pdf_folder, create = FALSE)

# Convert PDFs to text and saves in new folder
pdf_convert(med_pdf_folder, med_txt_folder)





#### Pre-Pandemic Data ####

# Filter to only unique DOIs and keep latest version of the paper
# First sort by descending version number so only most recent version is kept
med_data_2019 <- med_data_2019[order(-med_data_2019$version),] %>% distinct(doi, .keep_all = TRUE)

# Save
# TODO: Run
write_csv(med_data_2019, "outputs/control-data/med_data_2019.csv")

#### Download relevant papers ####
# Set up folders for download and txt conversion
med_pdf_folder_new <- paste0(getwd(), "/outputs/control-data/pdf-medRxiv")
med_txt_folder_new <- paste0(getwd(), "/outputs/control-data/text-medRxiv")

# Download all PDFs
med_data_2019 %>% mx_download(directory = med_pdf_folder_new, create = FALSE)

# Convert PDFs to text and saves in new folder
pdf_convert(med_pdf_folder_new, med_txt_folder_new)


#### Clean up ####
rm()
