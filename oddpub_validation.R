library(tidyverse)

arxiv_open_data_results <- 
  read_csv(here::here("outputs/data/arxiv_open_data_results.csv"))
# all_arxiv_results <- 
#   read_csv(here::here("outputs/data/arxiv_results.csv")) # All COVID arXiv papers (3,812)
arxiv_2019_open_data_results <- 
  read_csv(here::here("outputs/control-data/arxiv_2019_open_data_results.csv"))
# all_arxiv_2019_results <- 
#   read_csv(here::here("outputs/control-data/arxiv_data_2019.csv"))

# "attributes.has_data_links" gives indication of data availability
socarxiv_open_data_results <- 
  read_csv(here::here("outputs/data/socarxiv_open_data_results.csv"))
socarxiv_2019_open_data_results <- 
  read_csv(here::here("outputs/control-data/socarxiv_2019_open_data_results.csv"))
# socarxiv_metadata_2019 <- 
#   read_csv(here::here("outputs/control-data/socarxiv_metadata_2019.csv"))

#### SocArXiv ####

# 2019
# Check what's up with NA values attributes.has_data_links
# attributes.has_data_links: "available" means data link exists, everything else means data link does not exist. 
# NA appears to be the same as "not_applicable", meaning no data link and no justification (i.e. "attributes.why_no_data" is also NA).
# "no" means data was used but is not available. Justification must be provided in "attributes.why_no_data".
# Since ODDPub does not check for areas where open data is not applicable, we should go by 0/1 according to attributes.data_links being populated (i.e. "data_link_available" as defined above)
socarxiv_2019_open_data_results %>%
  mutate(data_link_available = case_when(is.na(attributes.data_links) ~ "No data linked", TRUE ~ "Data linked")) %>%
  count(data_link_available, is_open_data) %>%
  pivot_wider(names_from = is_open_data, values_from = n) %>%
  rename(`Open Data Detected` = `1`, `No Open Data Detected` = `0`)

# Unusually high amount of false positives; manual check
socarxiv_2019_open_data_results %>%
  filter(is_open_data == 1 & is.na(attributes.data_links)) %>%
  select(title, links.preprint_doi, attributes.has_data_links, attributes.why_no_data, attributes.data_links, is_open_data, open_data_category, open_data_statements) %>%
  View()

# Pandemic
socarxiv_open_data_results %>%
  mutate(data_link_available = case_when(is.na(attributes.data_links) ~ "No data linked", TRUE ~ "Data linked")) %>%
  count(data_link_available, is_open_data) %>%
  pivot_wider(names_from = is_open_data, values_from = n) %>%
  rename(`Open Data Detected` = `1`, `No Open Data Detected` = `0`)

# Same as above; manual check
socarxiv_open_data_results %>%
  filter(is_open_data == 1 & is.na(attributes.data_links)) %>%
  select(title, links.preprint_doi, attributes.has_data_links, attributes.why_no_data, attributes.data_links, is_open_data, open_data_category, open_data_statements) %>%
  View()

