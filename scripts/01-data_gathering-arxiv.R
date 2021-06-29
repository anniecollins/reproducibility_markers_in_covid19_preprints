#### Preamble ####
# Purpose: Download papers from arXiv that are related to COVID-19.
# Author: Rohan Alexander
# Data: 5 March 2021
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

# As of 22 May, 2021, 4,164 COVID-19 pre-prints (website count)


#### Get metadata ####
# Get count of number of papers using the same terms as before
arxiv_count('all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2"')
# Result on 22 May is: 4,054

# All records up to 1 May, 2021
arxiv_count('submittedDate:[20200101* TO 20210501*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")')
# Result on 22 May is: 3,932

arxiv_results <- arxiv_search(query = 'submittedDate:[20200101* TO 20210501*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2)"',
                    limit = 5000,
                    batchsize = 500)

arxiv_count('submittedDate:[20200101* TO 20200331*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")')
# There are 235 to get
arxiv_result_to_march <- 
  arxiv_search(query = 'submittedDate:[20200101* TO 20200331*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")',
               sort_by="submitted",
               limit = 3500,
               start = 0)
arxiv_result_to_march_ii <-
  arxiv_search(query = 'submittedDate:[20200101* TO 20200331*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")',
               sort_by="submitted",
               limit = 3500,
               start = 100)

# April 2020 to August 2020
arxiv_count('submittedDate:[20200401* TO 20200831*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")')
# There are 1831 to get
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

# Spetember 2020 to May 2021 (present)
arxiv_count('submittedDate:[20200901* TO 20210501*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")')
# There are 1829 to get
arxiv_result_sep_to_today <- 
  arxiv_search(query = 'submittedDate:[20200901* TO 20210501*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")',
               sort_by="submitted",
               limit = 3500)
arxiv_result_sep_to_today_ii <- 
  arxiv_search(query = 'submittedDate:[20200901* TO 20210501*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")',
               sort_by="submitted",
               start = 400,
               limit = 3500)


# n = 4,915 results total
all_arxiv_results <- 
  rbind(arxiv_result_to_march, arxiv_result_to_march_ii, arxiv_result_april_to_aug, 
        arxiv_result_april_to_aug_ii, arxiv_result_april_to_aug_iii, 
        arxiv_result_april_to_aug_iiii, arxiv_result_sep_to_today, arxiv_result_sep_to_today_ii)

# Filter for unique papers by ID; n = 3,896   
all_arxiv_results <- all_arxiv_results%>% distinct(id, .keep_all = TRUE)

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


#### Sample 1,000 papers ####

set.seed(50)
arxiv_sample <- all_arxiv_results[sample(nrow(all_arxiv_results), 1000),]
arxiv_sum <- arxiv_sample %>% mutate(month = substr(submitted, start = 1, stop = 7)) %>% group_by(month) %>% summarise(num=n())
write_csv(arxiv_sample, "outputs/data/arxiv_sample.csv")



# IF NECESSARY: Remove papers that are in folder but not in sample
# Use this if the arxiv_sample is changed but you want to keep any of the pdfs that are already saved locally so they don't have to be redownloaded
downloaded_pdf <- list.files("outputs/data/pdf-arxiv")
downloaded_txt <- list.files("outputs/data/text-arxiv")
# Delete downloaded pdfs that are not in the sample
delete_pdf <- downloaded_pdf %>% subset(!str_sub(downloaded_pdf, end = -5) %in% arxiv_sample$id)
delete_txt <- downloaded_txt %>% subset(!str_sub(downloaded_txt, end = -5) %in% arxiv_sample$id)
paste0("outputs/data/pdf-arxiv/", delete_pdf) %>% file.remove()
paste0("outputs/data/text-arxiv/", delete_txt) %>% file.remove()


#### Download PDFs ####
arxiv_sample <- 
  read_csv("outputs/data/arxiv_sample.csv")

# Set up folders for download and text conversion
arxiv_pdf_folder = paste0(getwd(), "/outputs/data/pdf-arxiv/")
arxiv_txt_folder = paste0(getwd(), "/outputs/data/text-arXiv/")

# Write a function
download_pdfs <- 
  function(link_to_pdf_of_interest, save_name){
    utils::download.file(link_to_pdf_of_interest, save_name, mode = "wb")
    message <- paste0("Done with ", link_to_pdf_of_interest, " at ", Sys.time())
    print(message)
    Sys.sleep(sample(x = c(5:10), size = 1))
    }

# Use the function
get_sample_arxiv_results <- 
  arxiv_sample %>% 
  # slice(1:2) %>% # Uncomment when testing 
  select(id, link_pdf) %>% 
  mutate(id = paste0(id, ".pdf"),
         link_pdf = paste0(link_pdf, ".pdf")
         ) %>% 
  mutate(id = paste0(arxiv_pdf_folder, id)) %>% 
  mutate(order = sample(x = c(1:nrow(arxiv_sample)),
                        size = nrow(arxiv_sample),
                        replace = FALSE)) %>% 
  arrange(order)

safely_download_pdfs <- purrr::safely(download_pdfs)

# Check what's already been downloaded
already_got <- list.files(path = arxiv_pdf_folder, full.names = TRUE)
# Remove those rows
get_sample_arxiv_results <- 
  get_sample_arxiv_results %>% 
  filter(!id %in% already_got)

purrr::walk2(get_sample_arxiv_results$link_pdf,
             get_sample_arxiv_results$id,
             safely_download_pdfs)

# Need to write a package that does this.
# Check if Annie has time - would be a nice companion package.

# Problem: some papers in sample don't actually have valid pdf links. They will show as having been downloaded but will not convert to text. 
# Use code below to identify non-downloaded pdfs if necessary.
downloaded_pdf <- list.files("outputs/data/pdf-arxiv")
downloaded_txt <- list.files("outputs/data/text-arxiv")

# for each pdf, cycle through all txt files, and if there is no doi from sample that corresponds to the pdf, remove it
not_working <- arxiv_sample %>% filter(!id %in% str_sub(downloaded_txt, end = -5))

# Remove not working files from the PDF output folder and sample data frame
pdf_files <- paste0(getwd(), "/outputs/data/pdf-arxiv/", not_working$id, ".pdf")
file.remove(pdf_files)
arxiv_sample <- arxiv_sample %>% filter(!id %in% not_working$id)

# Sample new papers (may need to change seed if this step is repeated)
set.seed(4200)
arxiv_sample_new <- all_arxiv_results[sample(nrow(all_arxiv_results), nrow(not_working)),]
# Check that new papers are not currently in the sample
# If line 202 returns any true values, repeat sample with different seed and check again
paste0(arxiv_sample_new$id, ".pdf") %in% downloaded_pdf
# If above is FALSE, bind to end of sample data and re-save sample frame
arxiv_sample <- rbind(arxiv_sample, arxiv_sample_new)
write_csv(arxiv_sample, "outputs/data/arxiv_sample.csv")

# Re-convert PDFs to text and saves in same folder (won't duplicate)
get_sample_arxiv_results <- 
  arxiv_sample %>% 
  # slice(1:2) %>% # Uncomment when testing 
  select(id, link_pdf) %>% 
  mutate(id = paste0(id, ".pdf"),
         link_pdf = paste0(link_pdf, ".pdf")
  ) %>% 
  mutate(id = paste0(arxiv_pdf_folder, id)) %>% 
  mutate(order = sample(x = c(1:nrow(arxiv_sample)),
                        size = nrow(arxiv_sample),
                        replace = FALSE)) %>% 
  arrange(order)

safely_download_pdfs <- purrr::safely(download_pdfs)

# Check what's already been downloaded
already_got <- paste0("http://arxiv.org/pdf/", list.files(path = arxiv_pdf_folder))
# Remove those rows
get_sample_arxiv_results <- 
  get_sample_arxiv_results %>% 
  filter(!link_pdf %in% already_got)

purrr::walk2(get_sample_arxiv_results$link_pdf,
             get_sample_arxiv_results$id,
             safely_download_pdfs)



#### Convert to text ####

# Convert PDFs to text and saves in new folder
oddpub::pdf_convert(arxiv_pdf_folder, arxiv_txt_folder)
# install.packages('Rpoppler')




#### Pre-pandemic data ####

### Get metadata ###
# All records from 2019
arxiv_count('submittedDate:[20190101* TO 20191231*]')
# Result on 22 May is: 155,455

arxiv_results_2019 <- arxiv_search(query = 'submittedDate:[20190101* TO 20190331*]',
                              limit = 1000,
                              batchsize = 500)

nums <- seq(from = 500, to = 42000, by = 500)

# Q1
for (num in nums) {
  arxiv_count('submittedDate:[20190101* TO 20190331*]')
  arxiv_results_2019_new <- arxiv_search(query = 'submittedDate:[20190101* TO 20190331*]',
                                         limit = 1000,
                                         batchsize = 500,
                                         start = num)
  arxiv_results_2019 <- rbind(arxiv_results_2019, arxiv_results_2019_new)
}

# Q2
for (num in nums) {
  arxiv_count('submittedDate:[20190401* TO 20190630*]')
  arxiv_results_2019_new <- arxiv_search(query = 'submittedDate:[20190101* TO 20190331*]',
                                         limit = 1000,
                                         batchsize = 500,
                                         start = num)
  arxiv_results_2019 <- rbind(arxiv_results_2019, arxiv_results_2019_new)
}

# Q3
for (num in nums) {
  arxiv_count('submittedDate:[201900701* TO 20190931*]')
  arxiv_results_2019_new <- arxiv_search(query = 'submittedDate:[20190101* TO 20190331*]',
                                         limit = 1000,
                                         batchsize = 500,
                                         start = num)
  arxiv_results_2019 <- rbind(arxiv_results_2019, arxiv_results_2019_new)
}

# Q4
for (num in nums) {
  arxiv_count('submittedDate:[20191001* TO 20191231*]')
  arxiv_results_2019_new <- arxiv_search(query = 'submittedDate:[20190101* TO 20190331*]',
                                         limit = 1000,
                                         batchsize = 500,
                                         start = num)
  arxiv_results_2019 <- rbind(arxiv_results_2019, arxiv_results_2019_new)
}

