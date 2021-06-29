#### Load data
bio_open_data_results <- read.csv("outputs/data/bio_open_data_results.csv")
bio_2019_open_data_results <- read.csv("outputs/control-data/bio_2019_open_data_results.csv")

med_open_data_results <- read.csv("outputs/data/med_open_data_results.csv")
med_2019_open_data_results <- read.csv("outputs/control-data/med_2019_open_data_results.csv")

arxiv_open_data_results <- read.csv("outputs/data/arxiv_open_data_results.csv")

socarxiv_open_data_results <- read.csv("outputs/data/socarxiv_open_data_results.csv")

#### Construct contingency tables
# TODO: simplify

# BioRxiv data before/during pandemic
bio_data_status <- bio_open_data_results %>% 
  count(is_open_data) %>% 
  mutate(status="During COVID-19", .before=is_open_data) %>% 
  pivot_wider(names_from = is_open_data, values_from=n)
bio_data_status <- bio_2019_open_data_results %>% 
  count(is_open_data) %>% 
  mutate(status="Pre-COVID-19", .before=is_open_data) %>% 
  pivot_wider(names_from = is_open_data, values_from=n) %>%
  rbind(bio_data_status)

bio_ContTable <- as.table(cbind(bio_data_status$`0`, bio_data_status$`1`))
dimnames(bio_ContTable) <- list(status = c("Pre-COVID-19", "During COVID-19"), data = c("NoOpenData", "OpenData"))

# BioRxiv code before/during pandemic
bio_code_status <- bio_open_data_results %>% 
  count(is_open_code) %>% 
  mutate(status="During COVID-19", .before=is_open_code) %>% 
  pivot_wider(names_from = is_open_code, values_from=n)
bio_code_status <- bio_2019_open_data_results %>% 
  count(is_open_code) %>% 
  mutate(status="Pre-COVID-19", .before=is_open_code) %>% 
  pivot_wider(names_from = is_open_code, values_from=n) %>%
  rbind(bio_code_status)

bio_code_ContTable <- as.table(cbind(bio_code_status$`0`, bio_code_status$`1`))
dimnames(bio_code_ContTable) <- list(status = c("Pre-COVID-19", "During COVID-19"), code = c("NoOpenCode", "OpenCode"))

# MedRxiv before/during pandemic
med_data_status <- med_open_data_results %>% 
  count(is_open_data) %>% 
  mutate(status="During COVID-19", .before=is_open_data) %>% 
  pivot_wider(names_from = is_open_data, values_from=n)
med_data_status <- med_2019_open_data_results %>% 
  count(is_open_data) %>% 
  mutate(status="Pre-COVID-19", .before=is_open_data) %>% 
  pivot_wider(names_from = is_open_data, values_from=n) %>%
  rbind(med_data_status)

med_ContTable <- as.table(cbind(med_data_status$`0`, med_data_status$`1`))
dimnames(med_ContTable) <- list(status = c("Pre-COVID-19", "During COVID-19"), data = c("NoOpenData", "OpenData"))

# MedRxiv before/during pandemic
med_code_status <- med_open_data_results %>% 
  count(is_open_code) %>% 
  mutate(status="During COVID-19", .before=is_open_code) %>% 
  pivot_wider(names_from = is_open_code, values_from=n)
med_code_status <- med_2019_open_data_results %>% 
  count(is_open_code) %>% 
  mutate(status="Pre-COVID-19", .before=is_open_code) %>% 
  pivot_wider(names_from = is_open_code, values_from=n) %>%
  rbind(med_code_status)

med_code_ContTable <- as.table(cbind(med_code_status$`0`, med_code_status$`1`))
dimnames(med_code_ContTable) <- list(status = c("Pre-COVID-19", "During COVID-19"), code = c("NoOpenCode", "OpenCode"))


# medRxiv by month during pandemic
med_month_data_status <- med_open_data_results %>% 
  mutate(month = str_sub(date, end=7)) %>%
  count(month, is_open_data) %>% 
  pivot_wider(names_from = is_open_data, values_from=n, values_fill=0)
med_month_ContTable <- as.table(cbind(med_month_data_status$`0`, med_month_data_status$`1`))
dimnames(med_month_ContTable) <- list(month = med_month_data_status$month, data = c("NoOpenData", "OpenData"))

# medRxiv by month during pandemic
bio_month_data_status <- bio_open_data_results %>% 
  mutate(month = str_sub(date, end=7)) %>%
  count(month, is_open_data) %>% 
  pivot_wider(names_from = is_open_data, values_from=n, values_fill=0)
bio_month_ContTable <- as.table(cbind(bio_month_data_status$`0`, bio_month_data_status$`1`))
dimnames(bio_month_ContTable) <- list(month = bio_month_data_status$month, data = c("NoOpenData", "OpenData"))

# All repos open data
med_data_status <- med_open_data_results %>% 
  count(is_open_data) %>% 
  mutate(repo="medRxiv", .before=is_open_data) %>% 
  pivot_wider(names_from = is_open_data, values_from=n)
bio_data_status <- bio_open_data_results %>% 
  count(is_open_data) %>% 
  mutate(repo="bioRxiv", .before=is_open_data) %>% 
  pivot_wider(names_from = is_open_data, values_from=n)
arxiv_data_status <- arxiv_open_data_results %>% 
  count(is_open_data) %>% 
  mutate(repo="arXiv", .before=is_open_data) %>% 
  pivot_wider(names_from = is_open_data, values_from=n)
socarxiv_data_status <- socarxiv_open_data_results %>% 
  count(is_open_data) %>% 
  mutate(repo="socArXiv", .before=is_open_data) %>% 
  pivot_wider(names_from = is_open_data, values_from=n)

all_data_status <- rbind(med_data_status, bio_data_status, arxiv_data_status, socarxiv_data_status)

all_status_ContTable <- as.table(cbind(all_data_status$`0`, all_data_status$`1`))
dimnames(all_status_ContTable) <- list(repo = all_data_status$repo, data = c("NoOpenData", "OpenData"))

# All repos open code
med_code_status <- med_open_data_results %>% 
  count(is_open_code) %>% 
  mutate(repo="medRxiv", .before=is_open_code) %>% 
  pivot_wider(names_from = is_open_code, values_from=n)
bio_code_status <- bio_open_data_results %>% 
  count(is_open_code) %>% 
  mutate(repo="bioRxiv", .before=is_open_code) %>% 
  pivot_wider(names_from = is_open_code, values_from=n)
arxiv_code_status <- arxiv_open_data_results %>% 
  count(is_open_code) %>% 
  mutate(repo="arXiv", .before=is_open_code) %>% 
  pivot_wider(names_from = is_open_code, values_from=n)
socarxiv_code_status <- socarxiv_open_data_results %>% 
  count(is_open_code) %>% 
  mutate(repo="socArXiv", .before=is_open_code) %>% 
  pivot_wider(names_from = is_open_code, values_from=n)

all_code_status <- rbind(med_code_status, bio_code_status, arxiv_code_status, socarxiv_code_status)

all_code_status_ContTable <- as.table(cbind(all_code_status$`0`, all_code_status$`1`))
dimnames(all_code_status_ContTable) <- list(repo = all_code_status$repo, data = c("NoOpenCode", "OpenCode"))

# MedRxiv published (data)
med_pub_data_status <- med_open_data_results %>% 
  count(published, is_open_data) %>% 
  # mutate(repo="medRxiv", .before=is_open_code) %>% 
  pivot_wider(names_from = is_open_data, values_from=n)
med_pub_data_ContTable <- as.table(cbind(med_pub_data_status$`0`, med_pub_data_status$`1`))
dimnames(med_pub_data_ContTable) <- list(published = c("No", "Yes"), data = c("NoOpenData", "OpenData"))

# BioRxiv published (data)
bio_pub_data_status <- bio_open_data_results %>% 
  count(published, is_open_data) %>% 
  # mutate(repo="bioRxiv", .before=is_open_code) %>% 
  pivot_wider(names_from = is_open_data, values_from=n)
bio_pub_data_ContTable <- as.table(cbind(bio_pub_data_status$`0`, bio_pub_data_status$`1`))
dimnames(bio_pub_data_ContTable) <- list(published = c("No", "Yes"), data = c("NoOpenData", "OpenData"))

# MedRxiv published (code)
med_pub_code_status <- med_open_data_results %>% 
  count(published, is_open_code) %>% 
  # mutate(repo="medRxiv", .before=is_open_code) %>% 
  pivot_wider(names_from = is_open_code, values_from=n)
med_pub_code_ContTable <- as.table(cbind(med_pub_code_status$`0`, med_pub_code_status$`1`))
dimnames(med_pub_code_ContTable) <- list(published = c("No", "Yes"), data = c("NoOpenCode", "OpenCode"))


#### Pearson Chi-squared test OR Fisher Exact tests (?)
# BioRxiv data
# p = 0.6146
bio_chitest <- chisq.test(bio_ContTable)

## BioRxiv code
# p = 0.0001059; looks like pandemic decreased amount of open code
bio_code_chitest <- chisq.test(bio_code_ContTable)

# MedRxiv data
# p = 0.004132; looks like pandemic lowered data availability
med_chitest <- chisq.test(med_ContTable)

# MedRxiv code
# p = 0.8573
med_code_chitest <- chisq.test(med_code_ContTable)

## MedRxiv Monthly
# p = 0.1829 (may be inaccurate)
med_month_chitest <- chisq.test(med_month_ContTable)

# BioRxiv Monthly
# p = 0.163 (may be inaccurate)
bio_month_chitest <- chisq.test(bio_month_ContTable)

# All repos (data)
# p < 2.2e-16; need to test pairwise differences
all_status_chitest <- chisq.test(all_status_ContTable)

# All repos (code)
# p < 2.2e-16; need to test pairwise differences
all_code_status_chitest <- chisq.test(all_code_status_ContTable)

# MedRxiv publication (data)
# p = 0.5717
med_pub_data_chitest <- chisq.test(med_pub_data_ContTable)

# BioRxiv publication (data)
# p = 0.5879
bio_pub_data_chitest <- chisq.test(bio_pub_data_ContTable)

# MedRxiv publication (code)
# p = 1
med_pub_code_chitest <- chisq.test(med_pub_code_ContTable)
