# Install specific packages
# devtools::install_github("mcguinlu/medrxivr")
# devtools::install_github("quest-bih/oddpub")
# install.packages("rbiorxiv")

library(tidyverse)
library(medrxivr)
library(rbiorxiv)
library(oddpub)

# Raw stats as of 31 Jan, 2021
# 12,776 COVID articles total
# 9,931 in medRxiv
# 2,845 in bioRxiv

# Download copy of current database
med_data <- mx_api_content(from_date = "2019-12-01", to_date = "2021-01-31", server = "medrxiv") # n = 20,108 (31 Jan, 2021)

# Search database for COVID-19-related articles by keyword across title, abstract, and category. Sort results from oldest to newest.
med_results <- mx_search(data = med_data, query = c("covid-19", "sars-cov-2", "coronavirus")) # n = 2,584 (31 Jan, 2021)
med_results <- med_results[order(med_results$date),]

# Summarise and graph by date
med_daily_sum <- med_results %>% group_by(date) %>% summarise(date = date, total = n())
med_plot <- med_daily_sum %>% ggplot() + geom_line(aes(x=date, y=total)) + geom_smooth(aes(x=date, y=total))

# Set up folders for download and txt conversion
med_pdf_folder = paste(getwd(), "/medRxiv PDFs", sep = "")
med_txt_folder = paste(getwd(), "/medRxiv Text", sep = "")

# Download first 500 papers and latest 500 and save to computer
head(med_results, 500) %>% mx_download(directory = med_pdf_folder, create = FALSE)
tail(med_results, 500) %>% mx_download(directory = med_pdf_folder, create = FALSE)

# Convert PDF's to text and saves in new folder
pdf_convert(med_pdf_folder, med_txt_folder)

# Load text files into list of string vectors for use in text mining algorithm.
# Returns list of lists, with one list for each document (paper)
med_text_sentences <- pdf_load(paste(med_txt_folder, "/", sep = "")) # Requires closing backslash

# CHECK FOR OPEN DATA MARKERS
med_open_data_results <- open_data_search(med_text_sentences)
count(med_open_data_results, is_open_data, is_open_code)


###### bioRxiv
# Download copy of current database

# dates <- seq.Date(from = as.Date("2019-12-01"), to = as.Date("2021-01-31"), by = 2)
# bio_data <- mx_api_content(from_date = as.character(dates[1]), to_date = as.character(dates[2]), server = "biorxiv")
# i = 200

# while (i < (length(dates) - 1)) {
#   bio_data2 <- try(mx_api_content(from_date = as.character(dates[i]), to_date = as.character(dates[i+1]), server = "biorxiv"))
#   if("try-error" %in% class(bio_data2)) {
#     bio_data2 <- mx_api_content(from_date = as.character(dates[i]), to_date = as.character(dates[i+2]), server = "biorxiv")
#     bio_data <- rbind(bio_data, bio_data2)
#     i <- i + 2
#   } else {
#     bio_data <- rbind(bio_data, bio_data2)
#     i <- i + 1
#   }
# }
