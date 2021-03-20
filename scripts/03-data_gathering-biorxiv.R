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

# Depending on i at end of loop may need to add in last few days of 2020 manually (if dates_2020[i] is 2020-12-29, run following)
bio_data_next <- mx_api_content(from_date = as.character(dates_2020[i]), to_date = as.character(dates_2020[i+1]), server = "biorxiv")
bio_data <- rbind(bio_data, bio_data_next)

# Retrieve data from 2021-01-01 to 2021-01-31, skipping 2021-01-08 (j = 8)
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

bio_data_next <- mx_api_content(from_date = as.character(dates_2021[j]), to_date = as.character(dates_2021[j+1]), server = "biorxiv")
bio_data <- rbind(bio_data, bio_data_next)

# Raw stats as of 31 Jan, 2021


# Search database for COVID-19-related articles by keyword across title, abstract, and category. Sort results from oldest to newest.
bio_results <- bio_data %>% filter(grepl("COVID-19|COVID 19|SARS-CoV-2|SARSCoV-2|corona virus|coronavirus|2019-nCoV|coronavirus-2", title, ignore.case = TRUE) |
                                     grepl("COVID-19|COVID 19|SARS-CoV-2|SARSCoV-2|corona virus|coronavirus|2019-nCoV|coronavirus-2", abstract, ignore.case = TRUE))

# Sometimes a paper has multiple versions
# Filter to only uniques and keep latest version of the paper (n = 3031)
bio_results <- bio_results[order(bio_results$version, decreasing = TRUE),] %>% distinct(doi, .keep_all = TRUE)

# Save results - this is sampling frame (info for all medRxiv COVID-19 papers)
write_csv(bio_results, "outputs/data/bio_results.csv")

# Summarise and graph by date
bio_daily_sum <- bio_results %>% count(date)
bio_plot <- bio_daily_sum %>% ggplot(aes(x=date, y=n)) + geom_line(group = 1)
bio_plot

# Sample from results
set.seed(100)
bio_sample <- bio_results[sample(nrow(bio_results), 1000),]
bio_sum <- bio_sample %>% count(floor_date(date, unit = "month"))
write_csv(bio_sample, "outputs/data/bio_sample.csv")

#### Download relevant papers ####
# Set up folders for download and txt conversion
bio_pdf_folder = paste(getwd(), "/outputs/data/pdf-bioRxiv", sep = "")
bio_txt_folder = paste(getwd(), "/outputs/data/text-bioRxiv", sep = "")

# Download first 500 papers and latest 500 and save to computer
bio_sample %>% mx_download(directory = bio_pdf_folder, create = FALSE)

# INTERIM: Remove papers in folder but not in sample
downloaded_pdf <- list.files("outputs/data/pdf-bioRxiv")
downloaded_txt <- list.files("outputs/data/text-bioRxiv")
# Take all but first 8 digits for each DOI in sample
sub_doi <- substr(bio_sample$doi, start = 9, stop = 100)
# for each pdf, cycle through all dois, and if there is no doi from sample that corresponds to the pdf, remove it
for (pdf in downloaded_pdf) {
  x <- FALSE
  for (doi in sub_doi) {
    if(grepl(doi, pdf)) {   # if there is a doi that matches the pdf, x is true
      x <- TRUE     # doi in downloads
    }
  } 
  if (!x) {  # if there is no doi that matches the pdf, remove it
    pdf_file <- paste(getwd(), "/outputs/data/pdf-bioRxiv", pdf, sep="/")
    file.remove(pdf_file)
  } 
  
}

# Convert PDFs to text and saves in new folder
pdf_convert(bio_pdf_folder, bio_txt_folder)


#### Clean up ####
rm()
