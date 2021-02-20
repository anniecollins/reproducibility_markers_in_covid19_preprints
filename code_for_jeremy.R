
library(tidyverse)

# Install the package to download arXiv
# See: https://amfz.github.io/arxivdl/
devtools::install_github("amfz/arxivdl")
library(arxivdl)

# Have a look at how many there are
count <- get_record_count("econ.GN", "20200101 TO 20201231")

# Get the information about them
papers <- get_records("econ.GN", "20200101 TO 20201231", count)

# Just get 10 to start
papers <- 
  papers %>% 
  slice(1:10)

# Do the actual download
download_pdf(papers, dir="~/")