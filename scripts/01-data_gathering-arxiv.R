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
# Result on 15 July is: 4,352

# All records up to 30 June, 2021
arxiv_count('submittedDate:[20200101* TO 20210630*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")')
# Result on 15 July is: 4280

arxiv_results <- arxiv_search(query = 'submittedDate:[20200101* TO 20210630*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2)"',
                    limit = 5000,
                    batchsize = 500)

arxiv_count('submittedDate:[20200101* TO 20200331*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")')
# There are 232 to get
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
               start = 1000)
arxiv_result_april_to_aug_iiii <- 
  arxiv_search(query = 'submittedDate:[20200401* TO 20200831*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")',
               sort_by="submitted",
               limit = 3500,
               start = 1700)

# Spetember 2020 to May 2021 (present)
arxiv_count('submittedDate:[20200901* TO 20210701*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")')
# There are 2181 to get
arxiv_result_sep_to_today <- 
  arxiv_search(query = 'submittedDate:[20200901* TO 20210630*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")',
               sort_by="submitted",
               limit = 3500)
arxiv_result_sep_to_today_ii <- 
  arxiv_search(query = 'submittedDate:[20200901* TO 20210630*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")',
               sort_by="submitted",
               start = 1300,
               limit = 3500)
arxiv_result_sep_to_today_iii <- 
  arxiv_search(query = 'submittedDate:[20200901* TO 20210701*] AND (all:"COVID-19" all:"COVID 19" all:"covid-19" all:"covid 19" all:"SARS-CoV-2" all:"SARSCoV-2" all:"corona virus" all:"Corona Virus" all:"coronavirus" all:"2019-nCoV" all:"coronavirus-2")',
               sort_by="submitted",
               start = 1500,
               limit = 3500)


# n = 4,915 results total
all_arxiv_results <- 
  rbind(arxiv_result_to_march, arxiv_result_to_march_ii, arxiv_result_april_to_aug, 
        arxiv_result_april_to_aug_ii, arxiv_result_april_to_aug_iii, 
        arxiv_result_april_to_aug_iiii, arxiv_result_sep_to_today, arxiv_result_sep_to_today_ii, arxiv_result_sep_to_today_iii)

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
downloaded_pdf <- list.files("outputs/data/pdf-arxiv/")
downloaded_txt <- list.files("outputs/data/text-arxiv/")

# for each pdf, cycle through all txt files, and if there is no doi from sample that corresponds to the pdf, remove it
not_working <- arxiv_sample %>% filter(!id %in% str_sub(downloaded_txt, end = -5))

# Remove not working files from the PDF output folder and sample data frame
pdf_files <- paste0(getwd(), "/outputs/data/pdf-arxiv/", not_working$id, ".pdf")
file.remove(pdf_files)
arxiv_sample <- arxiv_sample %>% filter(!id %in% not_working$id)

# Sample new papers (may need to change seed if this step is repeated)
set.seed(14)
arxiv_sample_new <- all_arxiv_results[sample(nrow(all_arxiv_results), nrow(not_working)),]
# Check that new papers are not currently in the sample
# If line 207 returns any true values, repeat sample with different seed and check again
paste0(arxiv_sample_new$id, ".pdf") %in% downloaded_pdf
# If all above is FALSE, delete "not_working" files, bind new sample to end of sample data and re-save sample frame
paste0(getwd(), "/outputs/data/pdf-arxiv/", not_working$id, ".pdf") %>% file.remove()
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

arxiv_results <- arxiv_search(query = 'submittedDate:[20190101* TO 20210630*]',
                              limit = 5000,
                              batchsize = 500)


# January
arxiv_count('submittedDate:[20190101* TO 20190131*]') # 11,039
arxiv_result_to_jan_i <- 
  arxiv_search(query = 'submittedDate:[20190101* TO 20190131*]',
               sort_by="submitted",
               limit = 3500,
               start = 0)
arxiv_result_to_jan_ii <- 
  arxiv_search(query = 'submittedDate:[20190101* TO 20190131*]',
               sort_by="submitted",
               limit = 3500,
               start = 2300)
arxiv_result_to_jan_iii <- 
  arxiv_search(query = 'submittedDate:[20190101* TO 20190131*]',
               sort_by="submitted",
               limit = 3500,
               start = 4100)
arxiv_result_to_jan_iv <- 
  arxiv_search(query = 'submittedDate:[20190101* TO 20190228*]',
               sort_by="submitted",
               limit = 3500,
               start = 5900)
arxiv_result_to_jan_v <- 
  arxiv_search(query = 'submittedDate:[20190101* TO 20190228*]',
               sort_by="submitted",
               limit = 3500,
               start = 7400)
arxiv_result_to_jan_vi <- 
  arxiv_search(query = 'submittedDate:[20190101* TO 20190228*]',
               sort_by="submitted",
               limit = 3500,
               start = 9000)
arxiv_result_to_jan_vii <- 
  arxiv_search(query = 'submittedDate:[20190101* TO 20190228*]',
               sort_by="submitted",
               limit = 3500,
               start = 10500)
arxiv_results_to_jan <- rbind(arxiv_result_to_jan_i, arxiv_result_to_jan_ii, arxiv_result_to_jan_iii, arxiv_result_to_jan_iv, arxiv_result_to_jan_v, arxiv_result_to_jan_vi, arxiv_result_to_jan_vii)


# February
arxiv_count('submittedDate:[20190201* TO 20190228*]') # 10,763
arxiv_result_to_feb_i <- 
  arxiv_search(query = 'submittedDate:[20190201* TO 20190228*]',
               sort_by="submitted",
               limit = 3500,
               start = 0)
arxiv_result_to_feb_ii <- 
  arxiv_search(query = 'submittedDate:[20190201* TO 20190228*]',
               sort_by="submitted",
               limit = 2700,
               start = 3500)
arxiv_result_to_feb_iii <- 
  arxiv_search(query = 'submittedDate:[20190201* TO 20190228*]',
               sort_by="submitted",
               limit = 3500,
               start = 6300)
arxiv_result_to_feb_iv <- 
  arxiv_search(query = 'submittedDate:[20190201* TO 20190228*]',
               sort_by="submitted",
               limit = 3500,
               start = 9800)
# arxiv_result_to_feb_v <- 
#   arxiv_search(query = 'submittedDate:[20190201* TO 20190228*]',
#                sort_by="submitted",
#                limit = 3500,
#                start = 7900)
# arxiv_result_to_feb_vi <- 
#   arxiv_search(query = 'submittedDate:[20190201* TO 20190228*]',
#                sort_by="submitted",
#                limit = 3500,
#                start = 8800)
# arxiv_result_to_feb_vii <- 
#   arxiv_search(query = 'submittedDate:[20190201* TO 20190228*]',
#                sort_by="submitted",
#                limit = 3500,
#                start = 10300)
arxiv_results_to_feb <- rbind(arxiv_result_to_feb_i,
                              arxiv_result_to_feb_ii,
                              arxiv_result_to_feb_iii,
                              arxiv_result_to_feb_iv)
                              # arxiv_result_to_feb_v,
                              # arxiv_result_to_feb_vi,
                              # arxiv_result_to_feb_vii)

# March
arxiv_count('submittedDate:[20190301* TO 20190331*]') # 12,865
arxiv_result_to_mar_i <- 
  arxiv_search(query = 'submittedDate:[20190301* TO 20190331*]',
               sort_by="submitted",
               limit = 3500,
               start = 0)
arxiv_result_to_mar_ii <- 
  arxiv_search(query = 'submittedDate:[20190301* TO 20190331*]',
               sort_by="submitted",
               limit = 200,
               start = 3500)
arxiv_result_to_mar_iii <- 
  arxiv_search(query = 'submittedDate:[20190301* TO 20190331*]',
               sort_by="submitted",
               limit = 3000,
               start = 3800)
arxiv_result_to_mar_iv <- 
  arxiv_search(query = 'submittedDate:[20190301* TO 20190331*]',
               sort_by="submitted",
               limit = 400,
               start = 5600)
arxiv_result_to_mar_v <- 
  arxiv_search(query = 'submittedDate:[20190301* TO 20190331*]',
               sort_by="submitted",
               limit = 3500,
               start = 6100)
arxiv_result_to_mar_vi <- 
  arxiv_search(query = 'submittedDate:[20190301* TO 20190331*]',
               sort_by="submitted",
               limit = 3500,
               start = 7900)
arxiv_result_to_mar_vii <- 
  arxiv_search(query = 'submittedDate:[20190301* TO 20190331*]',
               sort_by="submitted",
               limit = 3500,
               start = 11400)

arxiv_results_to_march <- rbind(arxiv_result_to_mar_i, arxiv_result_to_mar_ii, arxiv_result_to_mar_iii, arxiv_result_to_mar_iv, arxiv_result_to_mar_v, arxiv_result_to_mar_vi, arxiv_result_to_mar_vii)

# April
arxiv_count('submittedDate:[20190401* TO 20190430*]') # 12,411
arxiv_result_to_apr_i <- 
  arxiv_search(query = 'submittedDate:[20190401* TO 20190430*]',
               sort_by="submitted",
               limit = 500,
               start = 0)
arxiv_result_to_apr_ii <- 
  arxiv_search(query = 'submittedDate:[20190401* TO 20190430*]',
               sort_by="submitted",
               limit = 3500,
               start = 600)
arxiv_result_to_apr_iii <- 
  arxiv_search(query = 'submittedDate:[20190401* TO 20190430*]',
               sort_by="submitted",
               limit = 2800,
               start = 3400)
arxiv_result_to_apr_iv <- 
  arxiv_search(query = 'submittedDate:[20190401* TO 20190430*]',
               sort_by="submitted",
               limit = 1700,
               start = 5200)
arxiv_result_to_apr_v <- 
  arxiv_search(query = 'submittedDate:[20190401* TO 20190430*]',
               sort_by="submitted",
               limit = 1000,
               start = 7000)
arxiv_result_to_apr_vi <- 
  arxiv_search(query = 'submittedDate:[20190401* TO 20190430*]',
               sort_by="submitted",
               limit = 3500,
               start = 8100)
arxiv_result_to_apr_vii <- 
  arxiv_search(query = 'submittedDate:[20190401* TO 20190430*]',
               sort_by="submitted",
               limit = 3500,
               start = 9800)

arxiv_results_to_april <- rbind(arxiv_result_to_apr_i, arxiv_result_to_apr_ii, arxiv_result_to_apr_iii, arxiv_result_to_apr_iv, arxiv_result_to_apr_v, arxiv_result_to_apr_vi, arxiv_result_to_apr_vii)


# May
arxiv_count('submittedDate:[20190501* TO 20190531*]') # 13,289
arxiv_result_to_may_i <- 
  arxiv_search(query = 'submittedDate:[20190501* TO 20190531*]',
               sort_by="submitted",
               limit = 600,
               start = 0)
arxiv_result_to_may_ii <- 
  arxiv_search(query = 'submittedDate:[20190501* TO 20190531*]',
               sort_by="submitted",
               limit = 3500,
               start = 700)
arxiv_result_to_may_iii <- 
  arxiv_search(query = 'submittedDate:[20190501* TO 20190531*]',
               sort_by="submitted",
               limit = 800,
               start = 3600)
arxiv_result_to_may_iv <- 
  arxiv_search(query = 'submittedDate:[20190501* TO 20190531*]',
               sort_by="submitted",
               limit = 3500,
               start = 4500)
arxiv_result_to_may_v <- 
  arxiv_search(query = 'submittedDate:[20190501* TO 20190531*]',
               sort_by="submitted",
               limit = 3500,
               start = 5600)
arxiv_result_to_may_vi <- 
  arxiv_search(query = 'submittedDate:[20190501* TO 20190531*]',
               sort_by="submitted",
               limit = 3500,
               start = 7200)
arxiv_result_to_may_vii <- 
  arxiv_search(query = 'submittedDate:[20190501* TO 20190531*]',
               sort_by="submitted",
               limit = 3500,
               start = 8700)
arxiv_result_to_may_viii <- 
  arxiv_search(query = 'submittedDate:[20190501* TO 20190531*]',
               sort_by="submitted",
               limit = 3500,
               start = 12200)
arxiv_results_to_may <- rbind(arxiv_result_to_may_i, arxiv_result_to_may_ii, arxiv_result_to_may_iii, arxiv_result_to_may_iv, arxiv_result_to_may_v, arxiv_result_to_may_vi, arxiv_result_to_may_vii, arxiv_result_to_may_viii)


# June
arxiv_count('submittedDate:[20190601* TO 20190630*]') # 12,513
arxiv_result_to_jun_i <- 
  arxiv_search(query = 'submittedDate:[20190601* TO 20190630*]',
               sort_by="submitted",
               limit = 3500,
               start = 0)
arxiv_result_to_jun_ii <- 
  arxiv_search(query = 'submittedDate:[20190601* TO 20190630*]',
               sort_by="submitted",
               limit = 3500,
               start = 3500)
arxiv_result_to_jun_iii <- 
  arxiv_search(query = 'submittedDate:[20190601* TO 20190630*]',
               sort_by="submitted",
               limit = 3500,
               start = 7000)
arxiv_result_to_jun_iv <- 
  arxiv_search(query = 'submittedDate:[20190601* TO 20190630*]',
               sort_by="submitted",
               limit = 3500,
               start = 10500)
arxiv_result_to_jun_v <- 
  arxiv_search(query = 'submittedDate:[20190601* TO 20190630*]',
               sort_by="submitted",
               limit = 3500,
               start = 12000)
arxiv_results_to_june <- rbind(arxiv_result_to_jun_i, arxiv_result_to_jun_ii, arxiv_result_to_jun_iii, arxiv_result_to_jun_iv, arxiv_result_to_jun_v)


# July
arxiv_count('submittedDate:[20190701* TO 20190731*]') # 12,719
arxiv_result_to_jul_i <- 
  arxiv_search(query = 'submittedDate:[20190701* TO 20190731*]',
               sort_by="submitted",
               limit = 3500,
               start = 0)
arxiv_result_to_jul_ii <- 
  arxiv_search(query = 'submittedDate:[20190701* TO 20190731*]',
               sort_by="submitted",
               limit = 3500,
               start = 3300)
arxiv_result_to_jul_iii <- 
  arxiv_search(query = 'submittedDate:[20190701* TO 20190731*]',
               sort_by="submitted",
               limit = 3500,
               start = 6800)
arxiv_result_to_jul_iv <- 
  arxiv_search(query = 'submittedDate:[20190701* TO 20190731*]',
               sort_by="submitted",
               limit = 3500,
               start = 10300)
arxiv_result_to_jul_v <- 
  arxiv_search(query = 'submittedDate:[20190701* TO 20190731*]',
               sort_by="submitted",
               limit = 3500,
               start = 11100)

arxiv_results_to_july <- rbind(arxiv_result_to_jul_i, arxiv_result_to_jul_ii, arxiv_result_to_jul_iii, arxiv_result_to_jul_iv, arxiv_result_to_jul_v)

# August
arxiv_count('submittedDate:[20190801* TO 20190831*]') # 11,772
arxiv_result_to_aug_i <- 
  arxiv_search(query = 'submittedDate:[20190801* TO 20190831*]',
               sort_by="submitted",
               limit = 3500,
               start = 0)
arxiv_result_to_aug_ii <- 
  arxiv_search(query = 'submittedDate:[20190801* TO 20190831*]',
               sort_by="submitted",
               limit = 3500,
               start = 3500)
arxiv_result_to_aug_iii <- 
  arxiv_search(query = 'submittedDate:[20190801* TO 20190831*]',
               sort_by="submitted",
               limit = 3500,
               start = 6600)
arxiv_result_to_aug_iv <- 
  arxiv_search(query = 'submittedDate:[20190801* TO 20190831*]',
               sort_by="submitted",
               limit = 1800,
               start = 8300)
arxiv_result_to_aug_v <- 
  arxiv_search(query = 'submittedDate:[20190801* TO 20190831*]',
               sort_by="submitted",
               limit = 3500,
               start = 10200)
arxiv_results_to_august <- rbind(arxiv_result_to_aug_i, arxiv_result_to_aug_ii, arxiv_result_to_aug_iii, arxiv_result_to_aug_iv, arxiv_result_to_aug_v)

# September
arxiv_count('submittedDate:[20190901* TO 20190930*]') # 13,184
arxiv_result_to_sep_i <- 
  arxiv_search(query = 'submittedDate:[20190901* TO 20190930*]',
               sort_by="submitted",
               limit = 3500,
               start = 0)
arxiv_result_to_sep_ii <- 
  arxiv_search(query = 'submittedDate:[20190901* TO 20190930*]',
               sort_by="submitted",
               limit = 3500,
               start = 3500)
arxiv_result_to_sep_iii <- 
  arxiv_search(query = 'submittedDate:[20190901* TO 20190930*]',
               sort_by="submitted",
               limit = 3500,
               start = 5800)
arxiv_result_to_sep_iv <- 
  arxiv_search(query = 'submittedDate:[20190901* TO 20190930*]',
               sort_by="submitted",
               limit = 3500,
               start = 7500)
arxiv_result_to_sep_v <- 
  arxiv_search(query = 'submittedDate:[20190901* TO 20190930*]',
               sort_by="submitted",
               limit = 3500,
               start = 9600)
arxiv_result_to_sep_vi <- 
  arxiv_search(query = 'submittedDate:[20190901* TO 20190930*]',
               sort_by="submitted",
               limit = 3500,
               start = 10600)
arxiv_result_to_sep_vii <- 
  arxiv_search(query = 'submittedDate:[20190901* TO 20190930*]',
               sort_by="submitted",
               limit = 3500,
               start = 12200)
arxiv_results_to_september <- rbind(arxiv_result_to_sep_i, arxiv_result_to_sep_ii, arxiv_result_to_sep_iii, arxiv_result_to_sep_iv, arxiv_result_to_sep_v, arxiv_result_to_sep_vi, arxiv_result_to_sep_vii)

# October
arxiv_count('submittedDate:[20191001* TO 20191031*]') # 13,994
arxiv_result_to_oct_i <- 
  arxiv_search(query = 'submittedDate:[20191001* TO 20191031*]',
               sort_by="submitted",
               limit = 3500,
               start = 0)
arxiv_result_to_oct_ii <- 
  arxiv_search(query = 'submittedDate:[20191001* TO 20191031*]',
               sort_by="submitted",
               limit = 3500,
               start = 2600)
arxiv_result_to_oct_iii <- 
  arxiv_search(query = 'submittedDate:[20191001* TO 20191031*]',
               sort_by="submitted",
               limit = 3500,
               start = 6100)
arxiv_result_to_oct_iv <- 
  arxiv_search(query = 'submittedDate:[20191001* TO 20191031*]',
               sort_by="submitted",
               limit = 300,
               start = 8500)
arxiv_result_to_oct_v <- 
  arxiv_search(query = 'submittedDate:[20191001* TO 20191031*]',
               sort_by="submitted",
               limit = 3500,
               start = 8900)
arxiv_result_to_oct_vi <- 
  arxiv_search(query = 'submittedDate:[20191001* TO 20191031*]',
               sort_by="submitted",
               limit = 3500,
               start = 11100)
arxiv_result_to_oct_vii <- 
  arxiv_search(query = 'submittedDate:[20191001* TO 20191031*]',
               sort_by="submitted",
               limit = 3500,
               start = 13600)

arxiv_results_to_october <- rbind(arxiv_result_to_oct_i, arxiv_result_to_oct_ii, arxiv_result_to_oct_iii, arxiv_result_to_oct_iv, arxiv_result_to_oct_v, arxiv_result_to_oct_vi, arxiv_result_to_oct_vii)

rbind(arxiv_results_to_feb, 
      arxiv_results_to_march, 
      arxiv_results_to_april, 
      arxiv_results_to_may, 
      arxiv_results_to_june, 
      arxiv_results_to_july, 
      arxiv_results_to_august,
      arxiv_results_to_september,
      arxiv_results_to_october) %>% write_csv("outputs/control-data/arxiv_feb_to_oct_TO_FINISH.csv")

# November
arxiv_count('submittedDate:[20191101* TO 20191130*]') # 13,317
arxiv_result_to_nov_i <- 
  arxiv_search(query = 'submittedDate:[20191101* TO 20191130*]',
               sort_by="submitted",
               limit = 2100,
               start = 0)
arxiv_result_to_nov_ii <- 
  arxiv_search(query = 'submittedDate:[20191101* TO 20191130*]',
               sort_by="submitted",
               limit = 3200,
               start = 2200)
arxiv_result_to_nov_iii <- 
  arxiv_search(query = 'submittedDate:[20191101* TO 20191130*]',
               sort_by="submitted",
               limit = 3500,
               start = 5500)
arxiv_result_to_nov_iv <- 
  arxiv_search(query = 'submittedDate:[20191101* TO 20191130*]',
               sort_by="submitted",
               limit = 3500,
               start = 9000)
arxiv_result_to_nov_v <- 
  arxiv_search(query = 'submittedDate:[20191101* TO 20191130*]',
               sort_by="submitted",
               limit = 3500,
               start = 10700)
arxiv_results_to_november <- rbind(arxiv_result_to_nov_i, arxiv_result_to_nov_ii, arxiv_result_to_nov_iii, arxiv_result_to_nov_iv, arxiv_result_to_nov_v)

# December
arxiv_count('submittedDate:[20191201* TO 20191231*]') # 12,850
arxiv_result_to_dec_i <- 
  arxiv_search(query = 'submittedDate:[20191201* TO 20191231*]',
               sort_by="submitted",
               limit = 3500,
               start = 0)
arxiv_result_to_dec_ii <- 
  arxiv_search(query = 'submittedDate:[20191201* TO 20191231*]',
               sort_by="submitted",
               limit = 3500,
               start = 2300)
arxiv_result_to_dec_iii <- 
  arxiv_search(query = 'submittedDate:[20191201* TO 20191231*]',
               sort_by="submitted",
               limit = 3500,
               start = 5100)
arxiv_result_to_dec_iv <- 
  arxiv_search(query = 'submittedDate:[20191201* TO 20191231*]',
               sort_by="submitted",
               limit = 3500,
               start = 7100)
arxiv_result_to_dec_v <- 
  arxiv_search(query = 'submittedDate:[20191201* TO 20191231*]',
               sort_by="submitted",
               limit = 3500,
               start = 8500)
arxiv_result_to_dec_vi <- 
  arxiv_search(query = 'submittedDate:[20191201* TO 20191231*]',
               sort_by="submitted",
               limit = 3500,
               start = 10400)
arxiv_result_to_dec_vii <- 
  arxiv_search(query = 'submittedDate:[20191201* TO 20191231*]',
               sort_by="submitted",
               limit = 3500,
               start = 12200)
arxiv_results_to_december <- rbind(arxiv_result_to_dec_i, arxiv_result_to_dec_ii, arxiv_result_to_dec_iii, arxiv_result_to_dec_iv, arxiv_result_to_dec_v, arxiv_result_to_dec_vi, arxiv_result_to_dec_vii)

all_arxiv_results <- rbind(arxiv_results_to_jan,
                           arxiv_results_to_feb,
                           arxiv_results_to_march,
                           arxiv_results_to_april,
                           arxiv_results_to_may,
                           arxiv_results_to_june,
                           arxiv_results_to_july,
                           arxiv_results_to_august,
                           arxiv_results_to_september,
                           arxiv_results_to_october,
                           arxiv_results_to_november,
                           arxiv_results_to_december)

# Filter for unique papers
all_arxiv_results <- all_arxiv_results %>% distinct(id, .keep_all = TRUE)
# Check to see if all dates have been downloaded
substr(all_arxiv_results$submitted, 1, 10) %>% unique()

write_csv(all_arxiv_results, "outputs/control-data/arxiv_data_2019.csv")


# Create sample
set.seed(50)
arxiv_2019_sample <- all_arxiv_results[sample(nrow(all_arxiv_results), 1200),]
write_csv(arxiv_2019_sample, "outputs/control-data/arxiv_2019_sample.csv")

# Download PDFs
arxiv_2019_sample <- 
  read_csv("outputs/control-data/arxiv_2019_sample.csv")

# Set up folders for download and text conversion
arxiv_pdf_folder <- paste0(getwd(), "/outputs/control-data/pdf-arxiv/")
arxiv_txt_folder <- paste0(getwd(), "/outputs/control-data/text-arxiv/")

# Use the function
get_sample_arxiv_2019_results <- 
  arxiv_2019_sample %>% 
  # slice(1:2) %>% # Uncomment when testing 
  select(id, link_pdf) %>% 
  mutate(id = paste0(id, ".pdf"),
         link_pdf = paste0(link_pdf, ".pdf")
  ) %>% 
  mutate(id = paste0(arxiv_pdf_folder, id)) %>% 
  mutate(order = sample(x = c(1:nrow(arxiv_2019_sample)),
                        size = nrow(arxiv_2019_sample),
                        replace = FALSE)) %>% 
  arrange(order)

# Use download_pdfs from above
safely_download_pdfs <- purrr::safely(download_pdfs)

# Check what's already been downloaded
already_got <- list.files(path = arxiv_pdf_folder, full.names = TRUE) %>% str_replace("//", "/")

# Remove those rows
get_sample_arxiv_2019_results <- 
  get_sample_arxiv_2019_results %>% 
  filter(!id %in% already_got)

purrr::walk2(get_sample_arxiv_2019_results$link_pdf,
             get_sample_arxiv_2019_results$id,
             safely_download_pdfs)

# Convert to text
oddpub::pdf_convert(arxiv_pdf_folder, arxiv_txt_folder)

# Problem: some papers in sample don't actually have valid pdf links. They will show as having been downloaded but will not convert to text. 
# Use code below to identify non-downloaded pdfs if necessary.
downloaded_pdf <- list.files("outputs/control-data/pdf-arxiv")
downloaded_txt <- list.files("outputs/control-data/text-arxiv")

# for each pdf, cycle through all txt files, and if there is no doi from sample that corresponds to the pdf, remove it
not_working <- arxiv_2019_sample %>% filter(!id %in% str_sub(downloaded_txt, end = -5))

# Remove not working files from the PDF output folder and sample data frame
paste0(getwd(), "/outputs/control-data/pdf-arxiv/", not_working$id, ".pdf") %>% file.remove()
arxiv_2019_sample <- arxiv_2019_sample %>% filter(!id %in% not_working$id)

# Sample new papers (may need to change seed if this step is repeated)
set.seed(1050)
arxiv_2019_sample_new <- all_arxiv_results[sample(nrow(all_arxiv_results), nrow(not_working)),]
# Check that new papers are not currently in the sample
# If line 202 returns any true values, repeat sample with different seed and check again
paste0(arxiv_2019_sample_new$id, ".pdf") %in% downloaded_pdf
# If above is FALSE, bind to end of sample data and re-save sample frame
arxiv_2019_sample <- rbind(arxiv_2019_sample, arxiv_2019_sample_new)
write_csv(arxiv_2019_sample, "outputs/control-data/arxiv_2019_sample.csv")

# Re-convert PDFs to text and saves in same folder (won't duplicate)
arxiv_2019_sample <- read_csv("outputs/control-data/arxiv_2019_sample.csv")

get_sample_2019_arxiv_results <- 
  arxiv_2019_sample %>% 
  # slice(1:2) %>% # Uncomment when testing 
  select(id, link_pdf) %>% 
  mutate(id = paste0(id, ".pdf"),
         link_pdf = paste0(link_pdf, ".pdf")
  ) %>% 
  mutate(id = paste0(arxiv_pdf_folder, id)) %>% 
  mutate(order = sample(x = c(1:nrow(arxiv_2019_sample)),
                        size = nrow(arxiv_2019_sample),
                        replace = FALSE)) %>% 
  arrange(order)

safely_download_pdfs <- purrr::safely(download_pdfs)

# Check what's already been downloaded
already_got <- paste0("http://arxiv.org/pdf/", list.files(path = arxiv_pdf_folder))
# Remove those rows
get_sample_2019_arxiv_results <- 
  get_sample_2019_arxiv_results %>% 
  filter(!link_pdf %in% already_got)

purrr::walk2(get_sample_2019_arxiv_results$link_pdf,
             get_sample_2019_arxiv_results$id,
             safely_download_pdfs)

# Convert to text (won't duplicate)
oddpub::pdf_convert(arxiv_pdf_folder, arxiv_txt_folder)

