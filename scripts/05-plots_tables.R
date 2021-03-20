library(kableExtra)
library(tidyverse)
library(lubridate)

# Load Data
med_results <- read_csv("outputs/data/med_results.csv") # All COVID medRxiv papers (9,929)
med_open_data_results <- read_csv("outputs/data/med_open_data_results.csv") # Papers with ODDPub results

# Raw open data/code counts
med_open_data_results <- read_csv(here("outputs/data/med_open_data_results.csv"))
med_open_data_results %>% 
  count(is_open_data, is_open_code) %>%
  kable() %>%
  save_kable("outputs/figures/initial_sum_table.pdf")

# Summary Tables
med_month_sum <- 
  med_results %>% 
  group_by(month = floor_date(date, "month")) %>% 
  summarise(count=n())

med_month_sum_cov <- 
  med_open_data_results %>% 
  group_by(month = floor_date(date, "month")) %>% 
  summarise(count=n(), prop_open_code = sum(is_open_code)/n(), prop_open_data = sum(is_open_data)/n()) %>% 
  mutate(num_days = days_in_month(month),
         daily_rate = count/num_days)
# num_days <- c(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31)
# med_month_sum$daily_rate <- med_month_sum$count/num_days

# Publication status with open data/code counts
pub_data_count <- 
  med_open_data_results %>% 
  group_by(published) %>% 
  count(is_open_data) %>% 
  pivot_wider(names_from = is_open_data, values_from = n) %>%
  rename("Open Data Markers" = `0`, "No Data Code Markers" = `1`)
pub_data_count

pub_code_count <- 
  med_open_data_results %>% 
  group_by(published) %>% 
  count(is_open_code) %>% 
  pivot_wider(names_from = is_open_code, values_from = n) %>%
  rename("No Open Code Markers" = `0`, "Open Code Markers" = `1`)
pub_code_count


# Histogram of number of papers from sample in each month with total number of COVID papers published for each month
# All COVID papers
med_month_plot <- 
  med_month_sum %>% 
  ggplot(aes(month, count)) + 
  # geom_line(stat="identity") +
  geom_col() + 
  ggtitle("COVID-19 Papers Posted (Total)")
med_month_plot
ggsave("outputs/figures/papers_posted_total.pdf")

# Sampled COVID papers
med_month_cov_plot <- 
  med_month_sum_cov %>% 
  ggplot(aes(month, count)) + 
  geom_bar(stat="identity") + 
  ggtitle("COVID-19 Papers Posted (Sample)")
med_month_cov_plot
ggsave("outputs/figures/papers_posted_sample.pdf")

# % of papers with open data/code from sample per month
colors <- c("Data" = "red", "Code" = "blue")
open_rate_plot <- med_month_sum_cov %>% ggplot() +
            geom_line(data = med_month_sum_cov, aes(month, prop_open_data, color = "Data")) +
            geom_line(data = med_month_sum_cov, aes(month, prop_open_code, color = "Code")) +
            ggtitle("Proportion of Papers with Open Data or Code Markers by Month")
open_rate_plot
ggsave("outputs/figures/prop_open_per_month.pdf")

# Papers with open code/data per month from sample
# Create data frame
open_status <- 
  med_open_data_results %>% 
  select(title, date, is_open_code, is_open_data) %>% 
  mutate(condition = is_open_data + is_open_code)
open_status$condition[open_status$condition == 2] <- "Both"
open_status$condition[open_status$condition == 0] <- "Neither"
open_status$condition[open_status$condition == 1 & open_status$is_open_code == 1] <- "Open Code"
open_status$condition[open_status$condition == 1 & open_status$is_open_data == 1] <- "Open Data"

stack_conditions_plot <- 
  open_status %>% 
  ggplot() + 
  geom_bar(aes(x = factor(floor_date(date, "month")), 
               fill=factor(condition, levels = c("Neither", "Open Code", "Open Data", "Both")), 
               position = "stack")
           )
stack_conditions_plot
ggsave("outputs/figures/stack_conditions_plot.pdf")


# Type of Paper - subset data according to keywords for machine learning, simulation, and modeling
paper_type_keywords <- 
  med_open_data_results %>% select(title, abstract, date, is_open_code, is_open_data) %>% 
  mutate(condition = is_open_data + is_open_code)
paper_type_keywords$condition[paper_type_keywords$condition == 2] <- "Both"
paper_type_keywords$condition[paper_type_keywords$condition == 0] <- "Neither"
paper_type_keywords$condition[paper_type_keywords$condition == 1 & open_status$is_open_code == 1] <- "Open Code"
paper_type_keywords$condition[paper_type_keywords$condition == 1 & open_status$is_open_data == 1] <- "Open Data"
paper_type_keywords$machine_learning <- str_detect( paper_type_keywords$title, "machine learning") | 
                                          str_detect( paper_type_keywords$abstract, "machine learning")
paper_type_keywords$simulation <- str_detect( paper_type_keywords$title, "simulate|simulation|simulating") | 
                                    str_detect( paper_type_keywords$abstract, "simulate|simulation|simulating")
paper_type_keywords$model <- str_detect( paper_type_keywords$title, "modeling|model") | 
                                str_detect( paper_type_keywords$abstract, "modeling|model")
paper_type_keywords <- paper_type_keywords %>% 
  pivot_longer(cols = c("machine_learning", "simulation", "model"), names_to = "Type", values_to = "Value") %>%
  filter(Value == TRUE)
# Plot
paper_type_keywords_plot <- paper_type_keywords %>% ggplot() + 
  geom_bar(aes(x = Type, fill=factor(condition, levels = c("Neither", "Open Code", "Open Data", "Both")), position = "stack"))
paper_type_keywords_plot
ggsave("outputs/figures/paper_type_keywords_plot.pdf")

# Summary Table
paper_type_counts <- paper_type_keywords %>% 
  count(Type, condition) %>% 
  pivot_wider(names_from = condition, values_from = n, values_fill = 0) %>% 
  mutate(`Prop of Total w/ Open data and/or code`= (`Open Data` + `Open Code` + Both)/(`Open Data` + `Open Code` + Both + Neither))
paper_type_counts



# logit model: open data/code vs. time
# No significant results
open_code_time <- glm(is_open_code ~ date, family = binomial, data = med_open_data_results)
summary(open_code_time)

open_data_time <- glm(is_open_data ~ date, family = binomial, data = med_open_data_results)
summary(open_data_time)

typeof(med_open_data_results$date)
pub_model <- glm(published ~ as.factor(is_open_code) + as.factor(is_open_data), family = binomial, data = med_open_data_results)
summary(pub_model)