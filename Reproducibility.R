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
} # n = 89,540 (31 Jan, 2021)

# Search for COVID-19 papers
# mx_search function does not work on bioRxiv data for some reason; brute force using filter
bio_results <- bio_data %>% filter(grepl("sars-cov-2", title, fixed = TRUE) |
                                    grepl("sars-cov-2", abstract, fixed = TRUE) |
                                    grepl("sars-cov-2", category, fixed = TRUE) |
                                    grepl("covid-19", title, fixed = TRUE) |
                                    grepl("covid-19", abstract, fixed = TRUE) |
                                    grepl("covid-19", category, fixed = TRUE) |
                                    grepl("coronavirus", title, fixed = TRUE) |
                                    grepl("coronavirus", abstract, fixed = TRUE) |
                                    grepl("coronavirus", category, fixed = TRUE)) # n = 2,927 (31 Jan, 2021)

# Remove duplicate DOIs keeping highest version number
bio_results <- bio_results[order(bio_results[,'doi'], bio_results[,'version'], decreasing = TRUE),]
bio_unique <- bio_results[!duplicated(bio_results$doi),]
bio_results <- bio_unique[order(bio_unique$date),]


# Summarise and graph by date
bio_daily_sum <- bio_results %>% count(date)
bio_plot <- bio_daily_sum %>% ggplot() + geom_line(aes(x=date, y=n, group=1)) + geom_smooth(aes(x=date, y=n, group = 1))
bio_plot

bio_results %>% group_by(month = lubridate::floor_date(as.Date(date), "month")) %>% summarise(count = n())

# Set up folders for download and txt conversion
bio_pdf_folder = paste(getwd(), "/bioRxiv PDFs", sep = "")
bio_txt_folder = paste(getwd(), "/bioRxiv Text", sep = "")

# Download first all 1403 papers and save to computer
bio_results %>% mx_download(directory = bio_pdf_folder, create = FALSE)

# Convert PDF's to text and saves in new folder
pdf_convert(bio_pdf_folder, bio_txt_folder)

# Load text files into list of string vectors for use in text mining algorithm.
# Returns list of lists, with one list for each document (paper)
bio_text_sentences <- pdf_load(paste(bio_txt_folder, "/", sep = "")) # Requires closing backslash

# CHECK FOR OPEN DATA MARKERS
bio_open_data_results <- open_data_search(bio_text_sentences)
count(bio_open_data_results, is_open_data, is_open_code)
