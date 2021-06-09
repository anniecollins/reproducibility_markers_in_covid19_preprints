#### Preamble ####
# Purpose: Download papers from socarxiv that are related to COVID-19.
# Author: Rohan Alexander
# Data: 6 March 2021
# Contact: rohan.alexander@utoronto.ca
# License: MIT
# Pre-requisites: 
# - 


#### Workspace setup ####
# library(aRxiv)
library(httr)
library(lubridate)
library(tidyverse)
library(textreadr)
# library(lubridate)
# library(utils)
# library(purrr)
# library(lubridate)
# library(oddpub)


#### Get metadata ####
# Based on this: https://api.osf.io/v2/preprints/?filter[provider]=socarxiv
# all_socarxiv_papers <- httr::GET('https://api.osf.io/v2/preprints/?filter[provider]=socarxiv') # This only gets 10 so we need pagination
# socarxiv_papers_739 <- httr::GET('https://api.osf.io/v2/preprints/?filter%5Bprovider%5D=socarxiv&page=739')

# Write a function that will take a page and a save location and will got an GET that data and save it as a CSV.
get_meta_data_socarxiv <- 
  function(number, location){
    # number <- get_these$number[1] # Just for testing
    # location <- get_these$location[1] # Just for testing
    address <- paste0('https://api.osf.io/v2/preprints/?filter%5Bprovider%5D=socarxiv&page=', number)
    socarxiv_data_on_papers <- httr::GET(address)
    socarxiv_data_on_papers_as_dataset <- jsonlite::fromJSON(content(socarxiv_data_on_papers, "text"), flatten = TRUE)
    socarxiv_data_on_papers_as_tibble <- 
      socarxiv_data_on_papers_as_dataset$data %>% 
      as_tibble()
    socarxiv_data_on_papers_as_tibble <- 
      socarxiv_data_on_papers_as_tibble %>% 
      rowwise() %>% 
      mutate_if(is.list, ~paste(unlist(.), collapse = '|'))
    write_csv(socarxiv_data_on_papers_as_tibble, location)
    message <- paste0("Done with ", number, " at ", Sys.time())
    print(message)
    Sys.sleep(sample(x = c(5:10), size = 1))
  }

# Set up the dataset that we're going to walk though
# Check how many pages of results exist at https://api.osf.io/v2/preprints/?filter%5Bprovider%5D=socarxiv&page= and adjust numeric range accordingly
get_these <- 
  tibble(number = c(1:811),
         location  = paste0("inputs/socarxiv/", number, ".csv"))

safely_get_meta_data_socarxiv <- purrr::safely(get_meta_data_socarxiv)

# Check what's already been downloaded
already_got <- list.files(path = "inputs/socarxiv", full.names = TRUE)
# Remove those rows
get_these <- 
  get_these %>% 
  filter(!location %in% already_got)

# Use the function
purrr::walk2(get_these$number,
             get_these$location,
             safely_get_meta_data_socarxiv)

# Gather them all into one CSV
socarxiv_files <- list.files(path = "inputs/socarxiv", full.names = TRUE)

all_socarxiv_metadata <- purrr::map_dfr(socarxiv_files, 
                                        read_csv, 
                                        col_types = cols(.default = "c"))

#### Get COVID ones ####
# Identify which ones have something to do with COVID.
all_socarxiv_metadata <- 
  all_socarxiv_metadata %>% 
  rename(date_created = attributes.date_created,
         date_modified = attributes.date_modified,
         date_published = attributes.date_published,
         date_last_transitioned = attributes.date_last_transitioned,
         date_withdrawn = attributes.date_withdrawn,
         title = attributes.title,
         description = attributes.description,
         tags = attributes.tags
         ) %>% 
  mutate(date_created = lubridate::as_date(date_created),
         date_modified = lubridate::as_date(date_modified),
         date_published = lubridate::as_date(date_published),
         date_last_transitioned = lubridate::as_date(date_last_transitioned),
         date_withdrawn = lubridate::as_date(date_withdrawn)
         )

all_socarxiv_metadata <- 
  all_socarxiv_metadata %>% 
  filter(year(date_created) >= 2020)

query <- c("COVID-19|COVID 19|covid-19|covid 19|SARS-CoV-2|SARSCoV-2|corona virus|Corona Virus|coronavirus|2019-nCoV|coronavirus-2")

all_socarxiv_metadata <- 
  all_socarxiv_metadata %>% 
  mutate(covid_flag_title = 
           stringr::str_detect(string = title,
                               pattern = query),
         covid_flag_description = 
           stringr::str_detect(string = title,
                               pattern = query),
         covid_flag_tag = 
           stringr::str_detect(string = tags,
                               pattern = query),
         covid_flag = if_else(covid_flag_title == TRUE | 
                                covid_flag_description == TRUE | 
                                covid_flag_tag == TRUE,
                              TRUE,
                              FALSE)
         ) %>% 
  select(id, type, date_created, title, description, covid_flag_tag, covid_flag, covid_flag_title, everything()) %>% 
  
  select(-covid_flag_title, -covid_flag_description, -covid_flag_tag)

write_csv(all_socarxiv_metadata, "outputs/all_socarxiv_metadata.csv")


#### Download PDFs ####
covid_socarxiv_metadata <- 
  all_socarxiv_metadata %>% 
  filter(covid_flag == TRUE)

write_csv(covid_socarxiv_metadata, "outputs/data/socarxiv_results.csv")

utils::download.file("https://osf.io/preprints/socarxiv/2p3xt/download", 
                     "test.docx", 
                     mode = "wb")  

# Write a function
download_pdfs <- 
  function(link_to_pdf_of_interest, save_name){
    utils::download.file(link_to_pdf_of_interest, save_name, mode = "wb")
    message <- paste0("Done with ", link_to_pdf_of_interest, " at ", Sys.time())
    print(message)
    Sys.sleep(sample(x = c(5:10), size = 1))
  }


# Use the function
get_covid_socarxiv_results <- 
  covid_socarxiv_metadata %>%
  # slice(1:2) %>% # Uncomment when testing
  select(id) %>% 
  mutate(
    link_pdf = paste0("https://osf.io/preprints/socarxiv/", id, "/download"),
    save_name = paste0("outputs/data/pdf-socarxiv/", id, ".pdf")
  )

safely_download_pdfs <- purrr::safely(download_pdfs)

# Check what's already been downloaded
already_got <- list.files(path = "/outputs/data/pdf-socarxiv", full.names = TRUE)
# Remove those rows
get_covid_socarxiv_results <- 
  get_covid_socarxiv_results %>% 
  filter(!save_name %in% already_got)

# Download pdfs
# Warning: of sample, 65 papers are only available in .docx format. See below for continued download.
purrr::walk2(get_covid_socarxiv_results$link_pdf,
             get_covid_socarxiv_results$save_name,
             safely_download_pdfs)

#### Have a quick look ####
all_arxiv_results <- 
  read_csv("outputs/data/arxiv_results.csv")

all_arxiv_results <- 
  all_arxiv_results %>% 
  mutate(submitted = lubridate::as_date(submitted))

# Summarise and graph by date
all_arxiv_results %>% 
  filter(lubridate::year(submitted) >= 2020) %>% 
  count(submitted) %>% 
  ggplot() + 
  geom_col(aes(x=submitted, y=n))




#### Convert to text ####

# Set up folders for download and txt conversion
socarxiv_pdf_folder = paste0(getwd(), "/outputs/data/pdf-socarxiv")
socarxiv_txt_folder = paste0(getwd(), "/outputs/data/text-socarxiv")

# Convert PDFs to text and saves in new folder
oddpub::pdf_convert(socarxiv_pdf_folder, socarxiv_txt_folder)



# Some papers in only download as docx. 
# Use code below to identify pdfs that did not convert to txt (ie. those that did not download properly because they're docx files), then execute download process for docx files and convert to text in text folder.
downloaded_pdf <- list.files("outputs/data/pdf-socarxiv")
downloaded_txt <- list.files("outputs/data/text-socarxiv")

# for each pdf, cycle through all txt files, and if there is no key from sample that corresponds to the pdf, remove it
docx_files <- data.frame()
for (pdf in downloaded_pdf) {
  x <- FALSE
  for (txt in downloaded_txt) {
    if(grepl(substr(txt, 1, 5), pdf)) {   # if there is a txt that matches the pdf, x is true
      x <- TRUE     # doi in downloads
    }
  } 
  if (!x) {  # if there is no txt that matches the pdf, remove it
    file <- get_covid_socarxiv_results %>% filter(grepl(substr(pdf, 1, 5), link_pdf)) # Extract rows with pdf that's not converting
    docx_files <- rbind(docx_files, file)
  } 
}

# Change save_name to refer to doc-socarxiv folder, create new save_name column to refer to text-socarxiv
substr(docx_files$save_name, 14, 16) <- "doc"
docx_files$save_name <- substr(docx_files$save_name, 1, 32) %>% paste0("docx")
docx_files <- docx_files %>% 
  rename("link_doc" = "save_name") %>% 
  mutate(save_name = paste0(substr(link_doc, 1, 13), "text", substr(link_doc, 17, 26), id, ".txt"))


# Check what's already been downloaded
already_got <- list.files(path = paste0(getwd(), "/outputs/data/doc-socarxiv"), full.names = TRUE)
# Remove those rows
docx_files <- 
  docx_files %>% 
  filter(!(paste0(getwd(), link_doc) %in% already_got))

# Download docs
purrr::walk2(docx_files$link_pdf,
             docx_files$save_name,
             safely_download_pdfs)

# NEXT: read in docx files, either convert to text and save, or figure out way to make into "sentences" object for processing
# Check package "textreadr"

# Write function
doc_to_txt <-
  function(link_to_doc_of_interest, save_name){
    doc_content <- read_docx(link_to_doc_of_interest)
    write.table(doc_content, file = save_name)
    message <- paste0("Done with ", link_to_doc_of_interest, " at ", Sys.time())
    print(message)
    Sys.sleep(sample(x = c(5:10), size = 1))
  }

safely_doc_to_txt <- purrr::safely(doc_to_txt)

already_got <- list.files(path = paste0(getwd(), "/outputs/data/text-socarxiv"), full.names = TRUE)
# Remove those rows
docx_files <- 
  docx_files %>% 
  filter(!save_name %in% already_got)

# Convert docs to text files
purrr::walk2(docx_files$link_doc,
             docx_files$save_name,
             safely_doc_to_txt)