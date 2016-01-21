#' ---
#' Title: Some Common Errors and their Messages in R
#' Date: 2016-01-21
#' Author: 
#' ---

#' clear your workspace before running this
rm(list = ls())

#' What errors do these produce? Fix the code.
(1 + (2 * 4)


 1 + (2 * 3))

print("Hello, World!)

print(Hello, World!)

print(Hello)

print("R is awesome!"")

blah(2)

ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, colour = Species)) +
  geom_point()

2 + blah

2 + "blah"

#' Various attempts to extract columsn from a data frame
#' Which work? Which don't? Which give errors? 

iris
colnames(iris)
iris[ , "Species"]
iris[ , Species]
iris[["Species"]]
iris[[Species]]
iris[["blahblah"]]
iris[ , "blahblah"]

iris[["Species"]] <- NULL
iris[["Species"]]

read.csv("this_file_probably_does_not_exist.csv")

#' Load the package dplyr, then MASS
#' What messages do you see?
library(dplyr)
library(MASS)


#' Load the dataset mpg from ggplot2 and 
#' elect the variables `manufacturer`, `model`, and `year` from `mpg`.
data(mpg, package = "ggplot2")
select(mpg, manufacturer, model, year)


#' Try creating a plot with `ggplot`
 
ggplot <- function(x) print(x)

ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, colour = Species)) +
  geom_point()

