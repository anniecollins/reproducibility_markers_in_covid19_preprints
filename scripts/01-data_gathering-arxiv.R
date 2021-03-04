#### Preamble ####
# Purpose: Download papers from arXiv that are related to COVID-19.
# Author: Rohan Alexander
# Data: 4 March 2021
# Contact: rohan.alexander@utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need the following packages:
#   - install.packages("aRxiv")


#### Workspace setup ####
library(aRxiv)
library(tidyverse)
library(lubridate)
library(utils)
library(purrr)
# library(lubridate)
# library(oddpub)
citation('aRxiv')


#### Get metadata ####
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

purrr::walk2(get_all_arxiv_results$link_pdf,
             get_all_arxiv_results$id,
             safely_download_pdfs)

# Need to write a package that does this. Also that checks whether the file exists and then skips that.
# Check if Annie has time - woudl be a nice companion package.




#### Convert to text ####

# Set up folders for download and txt conversion
arxiv_pdf_folder = "/Volumes/Hansard/arxiv/"
arxiv_txt_folder = paste(getwd(), "/outputs/data/text-arXiv", sep = "")

# Convert PDFs to text and saves in new folder
oddpub::pdf_convert(arxiv_pdf_folder, arxiv_txt_folder)
# install.packages('Rpoppler')


