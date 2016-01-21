#' ---
#' Author: 
#' Title: "The Pipe Operator"
#' ---
library("dplyr")
library("magrittr")
library("gapminder")
data("gapminder")


#' Examples which can be rewritten using %>%
summarise(group_by(filter(gapminder, year == 2007),
                   continent),
          lifeExp = median(lifeExp))


#' Challenge
#' Rewrite these with %>%
summarize(group_by(gapminder, continent),
          n_obs = n(), n_countries = n_distinct(country))


tmp <- group_by(gapminder, continent, country)
tmp <- select(tmp, country, year, continent, lifeExp)
tmp <- mutate(tmp, le_delta = lifeExp - lag(lifeExp))
tmp <- summarize(tmp, worst_le_delta = min(le_delta, na.rm = TRUE))
tmp <- filter(tmp, min_rank(worst_le_delta) < 2)
tmp <- arrange(tmp, worst_le_delta)
tmp




