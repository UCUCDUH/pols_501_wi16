#' ----
#' title: Understanding Multiple Linear Regression
#' ---

library("dplyr")
library("broom")
library("ggplot2")
library("car")

devtools::install_github("UW-POLS501/r-uwpols501")

#' 
#' # Multiple Regression
#' 
#'  We will use the classic sociology data on Occuptational  Prestige and Income
#'  from Duncan (1950) included in the **car** package. It has the following
#'  variables:
#'  
#'  - `type`: Type of occupation. One of "wc" white collar, "bc" blue collar, and "prof" professional or managerial.
#'  - `income`: Percent of males in occupation earning $3500 or more in 1950
#'  - `education`: Percent of males in occupation in 1950 which were HS graduates.
#'  - `prestige`: Percent of survey respondents who rated the occupation as "excellent" or "good" in prestige.
#'  
data("Duncan", package = "car")

#' Use `help()` to learn more about the data

#' 
#' Regress prestige on income and occupation.
#' 
mod_all <- lm(prestige ~ income + education, data = Duncan)
summary(mod_all)

#'
#' Q: Interpret the coefficients
#' 

#' 
#' But what does the coefficient on education mean all else equal?
#' 
#' (1) regress prestige on education
#' 
mod1 <- lm(prestige ~ education, data = Duncan)
summary(mod1)

#'
#' Q: Is the coefficient on income the same as in the multiple regression model?
#' 

#' 
#' (2) regress income on education
#' 
mod2 <- lm(income ~ education, data = Duncan)
summary(mod2)

#' 
#' - What does this regression represent?
#' 

#' 
#' (3) Create a dataset with the residuals of mod1 and mod2
#' and regress the residuals of the regression `presige ~ income` on 
#' `income ~ education`
mod12_resid <- data_frame(prestige_resid = residuals(mod1),
                          income_resid = residuals(mod2))
mod3 <- lm(prestige_resid ~ income_resid, data = mod12_resid)
summary(mod3)

#' 
#' - What do the residuals of each regression represent?
#' - How does the coefficient in this regression relate to the coefficient on the regression 
#' - What does this say about how multiple regression works?
#' 

#' 
#' This method is good pedagogically for understanding the intuition behind multiple
#' regression coefficients "holding all else constant". However, this is not how
#' regression coefficients are calculated in practice. Also, note that the 
#' standard errors on the final equation are not correct.

#'
#' # Omitted Variable Bias
#' 
#' What was the regression coefficient of the regression of prestige on income, 
#' without controlling for education?

lm(prestige ~ income, data = Duncan)
lm(prestige ~ income + education, data = Duncan)

with(Duncan, cov(income, education))
with(Duncan, cov(prestige, education))

with(Duncan, {
  cov(income, education)
  cov(prestige, education)
})


#' 
#' - Is the coefficient of income greater or less than the one from the regression with education?
#' - Find the covariance (or correlation) between income and education, and between education and prestige.
#' - Based on the regression anatomy equation, can you explain this?
#' 


