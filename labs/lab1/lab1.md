# Lab 1: Reading Data in R

#### Jeff Arnold (Primary Instructor) & Andreu Casas (TA)

***

### Learning Objectives

1. Reading data in R's native format
2. Read and write CSVs
3. Read and write other type of data formats: STATA, SPSS, XLS...
4. Getting data from an external source
5. Searching and using replication data



***

### 1. Reading data in R's native format  

In this section we will see 2 different types of data. First, we will work with datasets that are part of R packages. Second, we will learn how to save and load data in the R's native format (.Rdata & .rda)    

Some R packages have datasets that you can load if you have those packages installed and loaded. For example, let's install the **gapminder** package. You need R version ≥ 3.1.0. If you have an older version, this is a good moment to go the [R Project website] (https://cran.fhcrc.org/) and update it.


```r
install.packages('gapminder')
library(gapminder)
```

We can take a look at what's in the package by using the help function: `help(<name-of-the-package>)` or `?<name-of-the-package>`


```r
?gapminder
```

The package documentation indicates that the package comes with a dataset named `gapminder`. To load the dataset in the R environment, we use the following function: `data(<name-of-the-dataset>)`. When loading datasets from packages we don't need to assign them to any object, they will be automatically loaded into the R enviornment and given the original dataset name


```r
data(gapminder)
```

We can now explore the **gapminder** dataset using the following functions:

- `dim` shows the dimensions of the data frame as the number of rows, columns
- `str` shows the internal structure of an R object
- `names` shows the column names of the data frame.
- `head` shows the first few observations
- `summary` calculates summary statistics for all variables in the data frame.


```r
dim(gapminder)
str(gapminder)
names(gapminder)
head(gapminder)
tail(gapminder)
summary(gapminder)
```

We can save any R object in our environment using R's native format: `.Rdata` & `.Rda`. In this case we use the `save(<name-of-the-object>)` function


```r
save(gapminder, file='gapminder.Rdata')
```

We can later load these R data files using the `load(<name-of-the-file>)` function. Let's delete the `gapminder` dataset that we curently have in the R environment and load it again using the `save()` function


```r
rm(gapminder)
load('gapminder.Rdata')
```







