library(tidyverse)


# function to fit the aov and run the multiple comparisons
run_multicomp <- function(data, group_var, continuous_var) {
  
  # to make this work in a pipe / make my life more difficult, I'm using quasiquotation here
  lhs <- pull(data, {{ continuous_var }})
  rhs <- as.factor(pull(data, {{ group_var }}))
  
  # first, fit an anova
  anova_result <- aov(lhs ~ rhs)
  
  # run multiple comparisons test, return the result
  multcomp::glht(model = anova_result, 
                 linfct = multcomp::mcp(rhs = "Tukey")) 
}


# function to grab the letters from the multiple comparisons result
grab_letters_df <- function(glht_obj, group_var, level = 0.05) {
  mcletters <- glht_obj %>% 
    multcomp::cld(level = level) %>% 
    pluck("mcletters")
  
  # we only really want a couple items out of this thing, 
  # make a data frame out of those including a column for the original treatment group
  tibble({{group_var}} := names(mcletters$Letters),
         letters       =  mcletters$Letters,
         letters_mono  =  mcletters$monospacedLetters)
}


# and a function to run the whole thing: 
# take an input dataset, run the multiple comparisons, and grab the letters as a data frame
make_multicomp_letters <- function(data, group_var, continuous_var, level = 0.05) {
  
  # first, run the multiple comparisons anova
  glht_result <- run_multicomp(data, 
                               group_var = {{ group_var }}, 
                               continuous_var = {{ continuous_var }})
  
  # then grab the letters, return that
  grab_letters_df(glht_result,
                  group_var = {{ group_var }},
                  level = level)
}



