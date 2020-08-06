library(tidyverse)

# identify a temporary directory to unpack the zip into
temp_dir <- tempdir()
unzip("for_adam.zip", exdir = temp_dir)

# grab all the folders that match "figure ##" and aren't in the __MACOSX directory
targ_dirs <- tibble(full_path = list.dirs(temp_dir)) %>% 
  filter(!str_detect(full_path, "__MACOSX"),
         str_ends(full_path, "figure [0-9]+"))

# function to move files
copy_directory <- function(read_location, write_location = "Data_In", clean_up = TRUE) {
  
  # if the directory doesnt exist in "./data" create it
  if (!dir.exists(write_location)) dir.create(write_location, recursive = TRUE)
  
  # copy all the files in the original
  file.copy(read_location, write_location, recursive = TRUE)
  
  # delete the original copy
  if (clean_up) unlink(read_location, recursive = TRUE)
  
  invisible(TRUE)
}

# run copy_directory for every folder
targ_dirs$full_path %>% 
  walk(copy_directory)
