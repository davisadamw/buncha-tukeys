library(tidyverse)
source("99_letters-functions.R")

# test method on fake data, goal here is A on its own, B and C matching, C and D matching, B and D not matching
fred <- crossing(nesting(gr = c("A", "B", "C", "D"),
                         u = c(0, 1.6, 1.8, 2.1)),
                 ob = 1:100) %>% 
  mutate(x = u + rnorm(n()),
         gr = as.factor(gr))


# first, fit an anova
anofred <- aov(x ~ gr, data = fred)

# run multiple comparisons test
fred_glht <- multcomp::glht(model = anofred, 
                            linfct = multcomp::mcp(gr = "Tukey")) 

fred_glht <- run_multicomp(fred, gr, x)

# view summary 
summary(fred_glht)

  
# grab the letterz (super weird data structure, but w/ee)
fred_letters <- grab_letters_df(fred_glht, gr)

# and just for comparison, make sure the full function runs the whole thing
make_multicomp_letters(fred, gr, x)
