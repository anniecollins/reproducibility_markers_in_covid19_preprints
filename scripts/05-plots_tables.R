# Load Data
med_results <- read_csv("outputs/data/med_results.csv")
med_open_data_results <- read_csv("outputs/data/med_open_data_results.csv")

# Raw open data/code counts
med_open_data_results <- read_csv(here("outputs/data/med_open_data_results.csv"))
med_open_data_results %>% 
  count(is_open_data, is_open_code) %>%
  kable() %>%
  save_kable("outputs/figures/initial_sum_table.pdf")

# Summary Tables
med_month_sum <- med_results %>% group_by(month = floor_date(date, "month")) %>% summarise(count=n())
med_month_sum_cov <- med_open_data_results %>% 
  group_by(month = floor_date(date, "month")) %>% 
  summarise(count=n(), prop_open_code = sum(is_open_code)/n(), prop_open_data = sum(is_open_data)/n())
num_days <- c(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31)
med_month_sum$daily_rate <- med_month_sum$count/num_days

# Publication status with open data/code counts
pub_data_count <- med_open_data_results %>% 
  group_by(published) %>% count(is_open_data) %>% 
  pivot_wider(names_from = is_open_data, values_from = n) %>%
  rename("Open Data Markers" = `TRUE`, "No Data Code Markers" = `FALSE`)

pub_code_count <- med_open_data_results %>% 
  group_by(published) %>% count(is_open_code) %>% 
  pivot_wider(names_from = is_open_code, values_from = n) %>%
  rename("No Open Code Markers" = `0`, "Open Code Markers" = `1`)


# Histogram of number of papers from sample in each month with total number of COVID papers published for each month
# All COVID papers
med_month_plot <- med_month_sum %>% ggplot(aes(month, count)) + geom_line(stat="identity") + ggtitle("COVID-19 Papers Posted (Total)")
med_month_plot
ggsave("outputs/figures/papers_posted_total.pdf")
# Sampled COVID papers
med_month_cov_plot <- med_month_sum_cov %>% ggplot(aes(month, count)) + geom_bar(stat="identity") + ggtitle("COVID-19 Papers Posted (Sample)")
med_month_cov_plot
ggsave("outputs/figures/papers_posted_sample.pdf")

# % of papers with open data/code from sample per month
colors <- c("Data" = "red", "Code" = "blue")
open_rate_plot <- med_month_sum_cov %>% ggplot() +
            geom_line(data = med_month_sum_cov, aes(month, prop_open_data, color = "Data")) +
            geom_line(data = med_month_sum_cov, aes(month, prop_open_code, color = "Code")) +
            ggtitle("Proporation of Papers with Open Data or Code Markers by Month")
open_rate_plot
ggsave("outputs/figures/prop_open_per_month.pdf")


# logit model: open data/code vs. time
open_code_time <- glm(is_open_code ~ date, family = binomial, data = med_open_data_results)
summary(open_code_time)

open_data_time <- glm(is_open_data ~ date, family = binomial, data = med_open_data_results)
summary(open_data_time)

typeof(med_open_data_results$date)
pub_model <- glm(published ~ is_open_code + is_open_data, family = binomial, data = med_open_data_results)
summary(pub_model)