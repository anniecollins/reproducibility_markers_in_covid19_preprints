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
dates_2020 <- seq.Date(from = as.Date("2019-12-01"), to = as.Date("2020-12-31"), by = 2)
dates_2021 <- seq.Date(from = as.Date("2021-01-01"), to = as.Date("2021-01-31"), by = "d")
bio_data <- mx_api_content(from_date = as.character(dates_2020[1]), to_date = as.character(dates_2020[2]), server = "biorxiv")
i <- 2
j <- 1

# Retrieve data from 2019-12-01 to 2020-12-31
while (i < (length(dates_2020) - 1)) {
  bio_data_next <- try(mx_api_content(from_date = as.character(dates_2020[i]), to_date = as.character(dates_2020[i+1]), server = "biorxiv"))
  if("try-error" %in% class(bio_data_next)) {
    bio_data_next <- mx_api_content(from_date = as.character(dates_2020[i]), to_date = as.character(dates_2020[i+2]), server = "biorxiv")
    bio_data <- rbind(bio_data, bio_data_next)
    i <- i + 2
  } else {
    bio_data <- rbind(bio_data, bio_data_next)
    i <- i + 1
  }
}

# Retrieve data from 2021-01-01 to 2021-01-31
while (j < (length(dates_2021) - 1)) {
  bio_data_next <- try(mx_api_content(from_date = as.character(dates_2021[j]), to_date = as.character(dates_2021[j]), server = "biorxiv"))
  if("try-error" %in% class(bio_data_next)) {
    bio_data_next <- mx_api_content(from_date = as.character(dates_2021[j]), to_date = as.character(dates_2021[j+1]), server = "biorxiv")
    bio_data <- rbind(bio_data, bio_data_next)
    j <- j + 2
  } else {
    bio_data <- rbind(bio_data, bio_data_next)
    j <- j + 1
  }
}

# Raw stats as of 31 Jan, 2021
# 12,776 COVID articles total
# 9,931 in medRxiv
# 2,845 in bioRxiv

# TODO: Search database for COVID-19-related articles by keyword across title, abstract, and category. Sort results from oldest to newest.


# Sometimes a paper has multiple versions
# Filter to only uniques and keep latest version of the paper
# TODO

# Summarise and graph by date
bio_daily_sum <- bio_results %>% group_by(date) %>% summarise(date = date, total = n())
bio_plot <- bio_daily_sum %>% ggplot() + geom_line(aes(x=date, y=total)) + geom_smooth(aes(x=date, y=total))


#### Download relevant papers ####
# Set up folders for download and txt conversion
bio_pdf_folder = paste(getwd(), "inputs/data/pdfs-bioRxiv", sep = "")
bio_txt_folder = paste(getwd(), "outputs/data/text-bioRxiv", sep = "")

# Download first 500 papers and latest 500 and save to computer
head(bio_results, 500) %>% mx_download(directory = bio_pdf_folder, create = FALSE)
tail(bio_results, 500) %>% mx_download(directory = bio_pdf_folder, create = FALSE)

# Convert PDFs to text and saves in new folder
pdf_convert(bio_pdf_folder, bio_txt_folder)


#### Clean up ####
rm()
