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
  
  # multcomp::cld generates lots of warnings that can be safely ignored
  # a quietly function will capture the warnings and let us decide which we want to pass forwards
  quiet_cld <- quietly(multcomp::cld)
  
  cld_result <- glht_obj %>% 
    quiet_cld(level = level)
  
  # check warnings, send along any that don't match our criteria to ignore
  cld_warnings <- cld_result$warnings
  if (length(cld_warnings) > 0) {
    cld_warnings_to_raise <- cld_warnings[!str_starts(cld_warnings, "Completion with")]
    if (length(cld_warnings_to_raise) > 0) warning(cld_warnings_to_raise)
  }
  
  # if the warnings weren't bad, keep the analysis going
  mcletters <- cld_result %>% 
    pluck("result", "mcletters")
  
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



