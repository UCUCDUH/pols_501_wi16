## ------------------------------------------------------------------------
library("dplyr")
library("tidyr")
library("gapminder")
data("gapminder")

#' 
gapminder %>%
  select(-continent) %>%
  gather(variable, value, -country, -year) %>%
  group_by(country, variable) %>%
  summarise(value = mean(value)) %>%
  spread(variable, value)


## ------------------------------------------------------------------------
gapminder %>%
  gather(variable, value, -country, -year) %>%
  group_by(country, variable) %>%
  summarise(mean = mean(value),
            sd = sd(value)) %>%
  gather(stat, value, -variable, -country) %>%
  unite(varname, variable, stat) %>%
  spread(varname, value)


