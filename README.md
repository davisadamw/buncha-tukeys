# Run a bunch of Tukey Honestly Significant Difference tests
make a bunch of tukey HSD tests with letters

R packages required are all included in tidyverse and multcomp

* 01_unpack-zip.R unzips for_adam into a temp directory, grabs the parts we care about, and puts them in Data_In
* 02_run-letters.R runs analysis, writes letters file (temporary)
* 03_merge-to-excel.R puts tries to drop the letters into excel document in the right place (or it would be if that weren't a huge pain ... did it manually)


* 10_check-tukey-hack.R tests the functions in 99 on fake data
* 99_IO-functions.R contains functions for reading and writing the data here
* 99_letters-functions.R contains the functions for running the stats and grabbing letters


