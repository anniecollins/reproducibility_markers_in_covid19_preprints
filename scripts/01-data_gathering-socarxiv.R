#### Preamble ####
# Purpose: Download papers from socarxiv that are related to COVID-19.
# Author: Rohan Alexander
# Data: 5 March 2021
# Contact: rohan.alexander@utoronto.ca
# License: MIT
# Pre-requisites: 
# - 


#### Workspace setup ####
# library(aRxiv)
library(httr)
library(tidyverse)
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
get_these <- 
  tibble(number = c(1:739),
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




# Need to map and read_csv
socarxiv_files <- list.files(path = "inputs/socarxiv", full.names = TRUE)

all_socarxiv_metadata <- purrr::map_dfr(socarxiv_files, read_csv, col_types = cols(.default = "c"))

write_csv(all_socarxiv_metadata, "outputs/all_socarxiv_metadata.csv")

###### UP TO HERE 


# Get count of number of papers using the same terms as before
arxiv_count('all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2"')
# Result on 20 Feb is: 3434.

arxiv_count('submittedDate:[20071018* TO 20210220*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")')
# Result on 20 Feb is: 3434.

arxiv_results <- arxiv_search(query = 'all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2"',
                    limit = 3500,
                    batchsize = 500)

arxiv_count('submittedDate:[20071018* TO 20200331*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")')
# There are 249 to get
arxiv_result_to_march <- 
  arxiv_search(query = 'submittedDate:[20071018* TO 20200331*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")',
               sort_by="submitted",
               limit = 3500,
               start = 100)
arxiv_result_to_march_ii <- 
  arxiv_search(query = 'submittedDate:[20071018* TO 20200331*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")',
               sort_by="submitted",
               limit = 3500,
               start = 100)

arxiv_count('submittedDate:[20200401* TO 20200831*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")')
# There are 1830 to get
arxiv_result_april_to_aug <- 
  arxiv_search(query = 'submittedDate:[20200401* TO 20200831*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")',
               sort_by="submitted",
               limit = 3500)
arxiv_result_april_to_aug_ii <- 
  arxiv_search(query = 'submittedDate:[20200401* TO 20200831*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")',
               sort_by="submitted",
               limit = 3500,
               start = 200)
arxiv_result_april_to_aug_iii <- 
  arxiv_search(query = 'submittedDate:[20200401* TO 20200831*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")',
               sort_by="submitted",
               limit = 3500,
               start = 700)
arxiv_result_april_to_aug_iiii <- 
  arxiv_search(query = 'submittedDate:[20200401* TO 20200831*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")',
               sort_by="submitted",
               limit = 3500,
               start = 1700)

arxiv_count('submittedDate:[20200901* TO 20210220*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")')
# There are 1320 to get
arxiv_result_sep_to_today <- 
  arxiv_search(query = 'submittedDate:[20200901* TO 20210220*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")',
               sort_by="submitted",
               limit = 3500)

all_arxiv_results <- 
  rbind(arxiv_result_to_march, arxiv_result_to_march_ii, arxiv_result_april_to_aug, 
        arxiv_result_april_to_aug_ii, arxiv_result_april_to_aug_iii, 
        arxiv_result_april_to_aug_iiii, arxiv_result_sep_to_today)

# Can't quite seem to get the all, but still have a lot
# Count says there are 3434, but only have 3379 from search.

# Save results - this is sampling frame (info for all arxiv COVID-19 papers)
write_csv(all_arxiv_results, "outputs/data/arxiv_results.csv")


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


#### Download PDFs ####
all_arxiv_results <- 
  read_csv("outputs/data/arxiv_results.csv")

# Write a function
download_pdfs <- 
  function(link_to_pdf_of_interest, save_name){
    utils::download.file(link_to_pdf_of_interest, save_name, mode = "wb")
    message <- paste0("Done with ", link_to_pdf_of_interest, " at ", Sys.time())
    print(message)
    Sys.sleep(sample(x = c(5:10), size = 1))
    }

# Use the function
get_all_arxiv_results <- 
  all_arxiv_results %>% 
  # slice(1:2) %>% # Uncomment when testing 
  select(id, link_pdf) %>% 
  mutate(id = paste0(id, ".pdf"),
         link_pdf = paste0(link_pdf, ".pdf")
         ) %>% 
  mutate(id = paste0("/Volumes/Hansard/arxiv/", id)) %>% 
  mutate(order = sample(x = c(1:nrow(all_arxiv_results)),
                        size = nrow(all_arxiv_results),
                        replace = FALSE)) %>% 
  arrange(order)

safely_download_pdfs <- purrr::safely(download_pdfs)

# Check what's already been downloaded
already_got <- list.files(path = "/Volumes/Hansard/arxiv", full.names = TRUE)
# Remove those rows
get_all_arxiv_results <- 
  get_all_arxiv_results %>% 
  filter(!id %in% already_got)

purrr::walk2(get_all_arxiv_results$link_pdf,
             get_all_arxiv_results$id,
             safely_download_pdfs)

# Need to write a package that does this.
# Check if Annie has time - would be a nice companion package.



#### Convert to text ####

# Set up folders for download and txt conversion
arxiv_pdf_folder = "/Volumes/Hansard/arxiv/"
arxiv_txt_folder = paste(getwd(), "/outputs/data/text-arXiv", sep = "")

# Convert PDFs to text and saves in new folder
oddpub::pdf_convert(arxiv_pdf_folder, arxiv_txt_folder)
# install.packages('Rpoppler')


