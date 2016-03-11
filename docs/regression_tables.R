#' ---
#' title: Example of Creating Regression Tables in R
#' author: Jeffrey Arnold
#' ---
library("car")
library("texreg")

data(Prestige)

mod1 <- lm(prestige ~ type, data = Prestige)
mod2 <- lm(prestige ~ income, data = Prestige)
mod3 <- lm(prestige ~ education, data = Prestige)
mod4 <- lm(prestige ~ type + education + income, data = Prestige)

#' If you load a HTML
htmlreg(list(mod1, mod2, mod3, mod4), file = "table.html")

#' If you using LaTeX
texreg(list(mod1, mod2, mod3, mod4), file = "table.tex")
