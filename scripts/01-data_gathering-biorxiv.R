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

# Raw stats as of 22 May, 2021 (from medRxiv website)
# 16,135 COVID articles total
# 12,450 in medRxiv
# 3,685 in bioRxiv

#### Get metadata ####
# Download copy of current database
dates_2020 <- seq.Date(from = as.Date("2020-01-01"), to = as.Date("2020-12-31"), by = 2)
dates_2021 <- seq.Date(from = as.Date("2021-05-01"), to = as.Date("2021-06-30"), by = "d")
bio_data <- mx_api_content(from_date = as.character(dates_2020[1]), to_date = as.character(dates_2020[2]), server = "biorxiv")
i <- 2
j <- 1

# Retrieve data from 2019-12-01 to 2020-12-31
# n = 83,253 as of 23 May, 2021
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
# n = 83,508 as of 23 May, 2021
bio_data_next <- mx_api_content(from_date = as.character(dates_2020[i]), to_date = as.character(dates_2020[i+1]), server = "biorxiv")
bio_data <- rbind(bio_data, bio_data_next)

# Retrieve data from 2021-01-01 to 2021-05-01, skipping 2021-01-08 (j = 8)
# n = 101,395 (total) as of 23 May, 2021
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
# TO HERE
bio_data_original <- read_csv("outputs/data/bio_results.csv")
bio_data <- rbind(bio_data_original, bio_data)
bio_data <- bio_data %>% distinct(doi, .keep_all = TRUE)
bio_data <- bio_data %>% filter(date < "2021-07-01" & year(date) > "2019")

# Depending on j at end of loop may need to add in last few days of 2021 range manually (if dates_2020[j] is 2021-04-30, run following)
# n = 101,654 (total) as of 23 May, 2021
bio_data_next <- mx_api_content(from_date = as.character(dates_2021[j]), to_date = "2021-07-01", server = "biorxiv")
bio_data <- rbind(bio_data, bio_data_next)

# Raw stats as of 31 Jan, 2021


# Search database for COVID-19-related articles by keyword across title, abstract, and category. Sort results from oldest to newest.
# n = 6,941 as of 23 May, 2021
bio_results <- bio_data %>% filter(grepl("COVID-19|COVID 19|SARS-CoV-2|SARSCoV-2|novel corona virus|novel coronavirus|2019-nCoV|coronavirus-2", title, ignore.case = TRUE) |
                                     grepl("COVID-19|COVID 19|SARS-CoV-2|SARSCoV-2|novel corona virus|novel coronavirus|2019-nCoV|coronavirus-2", abstract, ignore.case = TRUE))

# Sometimes a paper has multiple versions
# Filter to only uniques and keep latest version of the paper (n = 4,146)
bio_results <- bio_results[order(bio_results$version, decreasing = TRUE),] %>% distinct(doi, .keep_all = TRUE)

# Save results - this is sampling frame (info for all bioRxiv COVID-19 papers)
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
bio_pdf_folder = paste0(getwd(), "/outputs/data/pdf-bioRxiv")
bio_txt_folder = paste0(getwd(), "/outputs/data/text-bioRxiv")


# IF NECESSARY: Remove papers that are in folder but not in sample
# Use this if the bio_sample is changed but you want to keep any of the pdfs that are already saved locally so they don't have to be redownloaded
downloaded_pdf <- list.files("outputs/data/pdf-bioRxiv")
downloaded_txt <- list.files("outputs/data/text-bioRxiv")

# Remove files not in sample
pdf_file <- downloaded_pdf[!str_sub(downloaded_pdf, start = 10, end = -5) %in% str_sub(bio_sample$doi, start=9)]
txt_file <- downloaded_txt[!str_sub(downloaded_txt, start = 10, end = -5) %in% str_sub(bio_sample$doi, start=9)]
file.remove(paste0(getwd(), "/outputs/data/pdf-biorxiv/", pdf_file))
file.remove(paste0(getwd(), "/outputs/data/text-biorxiv/", txt_file))

# Download sampled papers as pdf
bio_sample %>% mx_download(directory = bio_pdf_folder, create = FALSE)

# Convert PDFs to text and saves in new folder
# DOI _10.1101_2020.10.10.334664 won't convert, delete PDF manually
pdf_convert(bio_pdf_folder, bio_txt_folder)

# Remove paper that did not download and sample another paper to replace file that does not exist
not_working <- bio_sample %>% filter(!str_sub(doi, start = 9) %in% str_sub(downloaded_txt, start = 10, end = -5)) %>% select(doi)
not_working <- downloaded_pdf[!str_sub(downloaded_pdf, start = 10, end = -5) %in% str_sub(downloaded_txt, start = 10, end = -5)]
file.remove(paste0(getwd(), "/outputs/data/pdf-biorxiv/", str_sub(not_working, end = -5), ".pdf"))
bio_sample <- bio_sample %>% filter(!str_sub(doi, start = 9) %in% str_sub(not_working, 10, -5))
# Sample additional paper from bio_data_2019
set.seed(190)
bio_new <- bio_results[sample(nrow(bio_results), length(not_working)),]
# Check that paper is not currently in the sample
downloaded_pdf <- list.files("outputs/data/pdf-bioRxiv") # Same as before
paste0("_10.1101_", str_sub(bio_new$doi, start=9), ".pdf") %in% downloaded_pdf
# If above is FALSE, bind to end of sample data and download pdf
bio_sample <- rbind(bio_sample, bio_new)
bio_sample %>% mx_download(directory = bio_pdf_folder, create = FALSE)
# Re-write sample csv
write_csv(bio_sample, "outputs/data/bio_sample.csv")
# Re-convert PDFs to text and saves in same folder (won't duplicate)
pdf_convert(bio_pdf_folder, bio_txt_folder)

#### Pre-pandemic data ####

#### Get metadata ####
# Download copy of current database
dates_2019 <- seq.Date(from = as.Date("2019-01-01"), to = as.Date("2019-12-31"), by = "week")
bio_data_2019 <- mx_api_content(from_date = as.character(dates_2019[1]), to_date = as.character(dates_2019[2]), server = "biorxiv")
i <- 2

# Retrieve data from 2019-01-01 to 2019-12-31
while (i < (length(dates_2019) - 1)) {
  bio_data_next <- try(mx_api_content(from_date = as.character(dates_2019[i]), to_date = as.character(dates_2019[i+1]), server = "biorxiv"))
  if("try-error" %in% class(bio_data_next)) {
    bio_data_next <- mx_api_content(from_date = as.character(dates_2019[i]), to_date = as.character(dates_2019[i+2]), server = "biorxiv")
    bio_data_2019 <- rbind(bio_data_2019, bio_data_next)
    i <- i + 2
  } else {
    bio_data_2019 <- rbind(bio_data_2019, bio_data_next)
    i <- i + 1
  }
}

# Depending on i at end of loop may need to add in last few days of 2019 manually (if dates_2019[i] is 2020-12-29, run following)
# n = 46,828 
bio_data_next <- mx_api_content(from_date = as.character(dates_2019[i]), to_date = as.character(dates_2019[i+1]), server = "biorxiv")
bio_data_2019 <- rbind(bio_data_2019, bio_data_next)

# Filter out any COVID-19 related papers using same words used to query above
bio_data_2019 <- bio_data_2019 %>% filter(!grepl("COVID-19|COVID 19|SARS-CoV-2|SARSCoV-2|novel corona virus|novel coronavirus|2019-nCoV|coronavirus-2", title, ignore.case = TRUE) &
                                     !grepl("COVID-19|COVID 19|SARS-CoV-2|SARSCoV-2|novel corona virus|novel coronavirus|2019-nCoV|coronavirus-2", abstract, ignore.case = TRUE))

# Sometimes a paper has multiple versions
# Filter to only uniques and keep latest version of the paper (n = 31,752)
bio_data_2019 <- bio_data_2019[order(bio_data_2019$version, decreasing = TRUE),] %>% distinct(doi, .keep_all = TRUE)

# Save results - this is sampling frame (info for all non-COVID-related bioRxiv papers posted in 2019)
write_csv(bio_data_2019, "outputs/control-data/bio_data_2019.csv")

# Sample from results
set.seed(100)
bio_sample_2019 <- bio_data_2019[sample(nrow(bio_data_2019), 1200),]
bio_sum <- bio_sample_2019 %>% count(substr(date, start=1, stop=7))
# Save sample data
write_csv(bio_sample_2019, "outputs/control-data/bio_sample_2019.csv")

#### Download relevant papers ####
# Set up folders for download and txt conversion
bio_pdf_folder = paste0(getwd(), "/outputs/control-data/pdf-bioRxiv")
bio_txt_folder = paste0(getwd(), "/outputs/control-data/text-bioRxiv")

# Download sampled papers as pdf
# Did not download DOI _10.1101_555631 (place 1166; insert 'slice(1167:1200) %>%' to get around)
bio_sample_2019 %>% mx_download(directory = bio_pdf_folder, create = FALSE)

# Remove paper that did not download and sample another paper to replace file that does not exist
bio_sample_2019 <- bio_sample_2019 %>% filter(doi != "10.1101/555631")
# Sample additional paper from bio_data_2019
set.seed(30)
bio_2019_new <- bio_data_2019[sample(nrow(bio_data_2019), 1),]
# Check that paper is not currently in the sample
downloaded_pdf_19 <- list.files("outputs/control-data/pdf-bioRxiv")
paste0("_10.1101_", substr(bio_2019_new$doi, start=9, stop=14), ".pdf") %in% downloaded_pdf_19
# If above is FALSE, bind to end of sample data and download pdf
bio_sample_2019 <- rbind(bio_sample_2019, bio_2019_new)
bio_sample_2019[1200,] %>% mx_download(directory = bio_pdf_folder, create = FALSE)
# Re-write sample csv
write_csv(bio_sample_2019, "outputs/control-data/bio_sample_2019.csv")


# Convert PDFs to text and saves in new folder
pdf_convert(bio_pdf_folder, bio_txt_folder)


#### Clean up ####
rm()
