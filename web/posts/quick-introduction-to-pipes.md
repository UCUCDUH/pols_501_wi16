<!-- 
.. title: Quick introduction to Pipes
.. slug: quick-introduction-to-pipes
.. date: 2016-01-09 21:16:57 UTC-08:00
.. tags: 
.. category: 
.. link: 
.. description: 
.. type: text
-->

The DataCamp [ggplot2](https://campus.datacamp.com/courses/data-visualization-with-ggplot2-1) uses the `%>%` operator in one [tutorial](https://campus.datacamp.com/courses/data-visualization-with-ggplot2-1/chapter-2-data?ex=10). The `%>%` is referred to as the pipe operator. 
The pipe operator comes from the R package **magrittr** (and **dplyr**), and is new feature in R, but one that has been quickly and widely adopted.
It most commonly used with the [dplyr](https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html) package for data manipulation and cleaning.
The data camp and lab next week will cover this in more detail.
But since we haven't covered this, here is a quick idea of what it does.
Suppose you have an R code that like this,
```
f(x, y)
```
The pipe operator allows you to write it as 
```
x %>% f(y)
```
where `x` will be the first argument of `f`.
This becomes useful when you are nesting many different functions, because you can write something like 
```
h(g(f(x, y), z))
```
in a more readable left-to-right form
```
x %>% f(y) %>% g(z) %>% h()
```

Here is another fake example from [Hadley Wickham](https://twitter.com/_inundata/status/557980236130689024) and based on the children's song, [Little Bunny Foo Foo](https://en.wikipedia.org/wiki/Little_Bunny_Foo_Foo),
``` R
foo_foo <- little_bunny()

bop_on(scoop_up(hop_through(foo_foo, forest), field_mouse), head)

# VS

foo_foo %>%
  hop_through(forest) %>%
  scoop_up(field_mouse) %>%
  bop_on(head)
```

A real example is the following. 
This code sorts a vector smallest to largest, and takes the mean of the squared difference between the values
``` R
library("dplyr")
x <- c(96, 12, 75, 19, 88)
mean(diff(sort(x)))
```
With nested functions the order of operations happens from the middle-out.
With pipes we can rewrite it as 
``` R
x %>% sort() %>% diff() %>% mean()
```
With this the functions in the code are written the same order as the operations, which makes the steps easier to follow: First sort the vector, then take the difference, then take the mean.

