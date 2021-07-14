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
med_data <- med_data %>% filter(date >= "2019-12-01", date <= "2021-06-30")
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
                                                    "coronavirus-2"), auto_caps = TRUE) # n = 13,194
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
med_pdf_folder = paste0(getwd(), "/outputs/data/pdf-medRxiv")
med_txt_folder = paste0(getwd(), "/outputs/data/text-medRxiv")

downloaded_pdf <- list.files("outputs/data/pdf-medRxiv")
downloaded_txt <- list.files("outputs/data/text-medRxiv")
# Remove files not in sample
pdf_file <- downloaded_pdf[!str_sub(downloaded_pdf, start = -23, end = -5) %in% str_sub(med_sample$doi, start=9)]
txt_file <- downloaded_txt[!str_sub(downloaded_txt, start = 15) %in% paste0(str_sub(med_sample$doi, start=9), ".txt")]
file.remove(paste0(getwd(), "/outputs/data/pdf-medrxiv/", pdf_file))
file.remove(paste0(getwd(), "/outputs/data/text-medrxiv/", txt_file))

downloaded_pdf <- list.files("outputs/data/pdf-medRxiv")
get_covid_med_results <- med_sample %>% filter(!str_sub(doi, start=9) %in% str_sub(downloaded_pdf, start = 15, end = -5))

# Download randomly sampled PDFs (will not)
# Stopped at row 1067 (broken URL?); added slice to skip entry after pause
get_covid_med_results %>% mx_download(directory = med_pdf_folder, create = FALSE)

# Convert PDFs to text and saves in new folder
pdf_convert(med_pdf_folder, med_txt_folder)

# PROBLEM: some PDFs won't convert to text
downloaded_pdf <- list.files("outputs/data/pdf-medRxiv")
downloaded_txt <- list.files("outputs/data/text-medRxiv")
not_working <- med_sample %>% filter(!paste0(str_sub(doi, start=9), ".txt") %in% str_sub(downloaded_txt, start = -23))
# Remove file that isn't working
pdf_file <- paste0(getwd(), "/outputs/data/pdf-medRxiv/", not_working$ID, "_10.1101_", str_sub(not_working$doi, start=9), ".pdf")
file.remove(pdf_file)
med_sample <- med_sample %>% filter(!doi %in% not_working$doi)

# Sample new papers (may need to change seed if this step is repeated)
set.seed(51)
medrxiv_sample_new <- med_results[sample(nrow(med_results), nrow(not_working)),]
# Check that new papers are not currently in the sample
# If line 99 returns any true values, repeat sample with different seed and check again
downloaded_pdf <- list.files("outputs/data/pdf-medRxiv")
paste0(medrxiv_sample_new$ID, "_10.1101_", str_sub(medrxiv_sample_new$doi, start=9), ".pdf") %in% downloaded_pdf
# If above is FALSE, bind to end of sample data and re-save sample frame
med_sample <- rbind(med_sample, medrxiv_sample_new)
write_csv(med_sample, "outputs/data/med_sample.csv")
# Re-download PDFs
# med_pdf_folder = paste0(getwd(), "/outputs/data/pdf-medRxiv")
med_txt_folder = paste0(getwd(), "/outputs/data/text-medRxiv")
med_sample %>% mx_download(directory = med_pdf_folder, create = FALSE)

# Convert PDFs (will not duplicte)
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
