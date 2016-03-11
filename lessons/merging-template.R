#' ---
#' Title: Joining Data in R
#' Date: 2016-01-21
#' Author:
#' ---
library("dplyr")

#' Example datasets
foo <- data_frame(x = c("a", "b", "c", "d"),
                  y = 1:4)
bar <- data_frame(x = c("a", "b", "e", "f"),
                  z = 1:4 * 10)



bar2 <- data_frame(x2 = c("a", "b", "e", "f"),
                   z = 1:4 * 10)



baz <- data_frame(x = c("alpha", "bravo", "charlie", "delta"),
                  z = 1:4 * 10)



quux <- data_frame(x = c("a", "b", "e", "f"),
                   y = 1:4 * 10)


qux <- data_frame(xx = c("a", "b", "c", "d"),
                  yy = 1:4 * 10)


corge <- data_frame(x = c("e", "f", "g", "h"), y = 5:8)

