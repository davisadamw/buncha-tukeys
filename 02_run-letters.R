library(tidyverse)
source("99_letters-functions.R")
source("99_IO-functions.R")

# identify the source files
all_sources <- list.files("Data_In", pattern = "source.csv", recursive = TRUE, full.names = TRUE)

all_source_data <- tibble(fullpath = all_sources,
                          figure   = basename(dirname(fullpath)),
                          file     = basename(fullpath)) %>% 
  # read each dataset and extract the target variable
  mutate(data     = map(fullpath, read_csv_source),
         targ_var = map_chr(data, ~ unique(.$targ_var)))

# now, run the anova -> letters on each dataset ... throws an error, but it doesn't seem to be a problem
all_source_letters <- all_source_data %>% 
  mutate(letters_df = map(data, 
                          make_multicomp_letters, 
                          group_var = vehicle_model,
                          continuous_var = target),
         .keep = "unused") %>% 
  unnest(letters_df)

# store significance results in a temporary file
all_source_letters %>% 
  write_rds("sig_results.rds")
