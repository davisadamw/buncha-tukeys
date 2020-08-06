library(tidyverse)

# reader basically just skips the first column (rownames), renames the last column "target", and saves the original target column name
read_csv_source <- function(filename) {
  
  # read existing column names, convert to a character vector
  names_only <- read_csv(filename, col_names = FALSE, n_max = 1, col_types = "cccc") %>% 
    map_chr(~ .) %>% 
    unname()
  
  # save the name of the target var for future use
  targ_var <- names_only[4]
  
  # but we want to read it in with the name "target" to make processing easier
  names_only[4] <- "target"
  
  # finally, read the data and add a column identifying the target variable
  read_csv(filename, col_names = names_only[-1], col_types = "_ccd", skip = 1) %>% 
    mutate(targ_var = targ_var, .before = 3)
}
